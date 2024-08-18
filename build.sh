#!/QOpenSys/usr/bin/qsh
#----------------------------------------------------------------
# Script name: build.sh
# Author: Richard Schoen
# Purpose: Create QSHONI library, copy source members, and compile objects
#----------------------------------------------------------------

SRCLIB="QSHONI"
SRCLIBTEXT="QShell on IBM i"
SRCFILE="SOURCE"
SRCCCSID="37"
dashes="---------------------------------------------------------------------------"

function cpy_member {
  # ----------------------------------------------------------------
  # Copy source member and set source type
  # ----------------------------------------------------------------
  SRCMEMBER=$(echo "${CURFILE^^}" | cut -d'.' -f1)  # Parse PC file name prefix to member name
  SRCTYPE=$(echo "${CURFILE^^}" | cut -d'.' -f2)    # Parse PC file name extension to source type
  system -v "CPYFRMSTMF FROMSTMF('${PWD}/${CURFILE}') TOMBR('/QSYS.LIB/${SRCLIB}.LIB/${SRCFILE}.FILE/${SRCMEMBER}.MBR') MBROPT(*REPLACE)" 
  system -v "CHGPFM FILE(${SRCLIB}/${SRCFILE}) MBR($SRCMEMBER) SRCTYPE(${SRCTYPE}) TEXT('${SRCTEXT}')"
}

function compile_member {
  # ----------------------------------------------------------------
  # Compile source member based on type
  # ----------------------------------------------------------------
  SRCMEMBER=$(echo "${CURFILE^^}" | cut -d'.' -f1)  # Parse PC file name prefix to member name
  SRCTYPE=$(echo "${CURFILE^^}" | cut -d'.' -f2)    # Parse PC file name extension to source type

  declare -A CMD_TO_PGM_MAP=(
    ["QSHPATH"]="QSHPATHC"
    ["QSHEXEC"]="QSHEXECC"
    ["QSHLOGSCAN"]="QSHLOGSCAC"
    ["QSHBASH"]="QSHBASHC"
    ["QSHIFSCHK"]="QSHIFSCHKC"
    ["QSHPYRUN"]="QSHPYRUNC"
    ["QSHPHPRUN"]="QSHPHPRUNC"
    ["QSHQRYTMP"]="QSHQRYTMPC"
    ["QSHSETPROF"]="QSHSETPROC"
    ["QSHCURL"]="QSHCURLC"
    ["QSHPORTCHK"]="QSHPORTCHC"
    ["QSHPORTEND"]="QSHPORTENC"
    ["QSHEXECSRC"]="QSHEXECSCC"
    ["DB2UTIL"]="DB2UTILC"
    ["QSHGETPARM"]="QSHGETPARR"
    ["QSHPYCALL"]="QSHPYCALLC"
    ["QSHCALL"]="QSHCALLC"
    ["QSHCPYSRC"]="QSHCPYSRCC"
    ["QSHBASHSRC"]="QSHBASHSCC"
    ["QSHIFSSIZ"]="QSHIFSSIZC"
    ["QSHSAVLIB"]="QSHSAVLIBC"
    ["QSHSAVIFS"]="QSHSAVIFSC"
    ["QSHQRYSRC"]="QSHQRYSRCC"
  )

  case "$SRCTYPE" in
    "CMD")
      TARGET_PGM=${CMD_TO_PGM_MAP[$SRCMEMBER]}
      if [ -z "$TARGET_PGM" ]; then
        echo "No mapping found for $SRCMEMBER"
        return
      fi
      COMPILE_CMD="CRTCMD CMD(${SRCLIB}/${SRCMEMBER}) PGM(${SRCLIB}/${TARGET_PGM}) SRCFILE(${SRCLIB}/${SRCFILE}) SRCMBR($SRCMEMBER) THDSAFE(*YES) REPLACE(*YES)"
      ;;
    "CLLE")
      COMPILE_CMD="CRTBNDCL PGM(${SRCLIB}/${SRCMEMBER}) SRCFILE(${SRCLIB}/${SRCFILE}) SRCMBR($SRCMEMBER) DFTACTGRP(*NO) ACTGRP(*CALLER) REPLACE(*YES) DBGVIEW(*ALL) USRPRF(*OWNER)"
      ;;
    "RPGLE")
      COMPILE_CMD="CRTBNDRPG PGM(${SRCLIB}/${SRCMEMBER}) SRCFILE(${SRCLIB}/${SRCFILE}) SRCMBR($SRCMEMBER) DFTACTGRP(*NO) ACTGRP(*CALLER) REPLACE(*YES) DBGVIEW(*ALL)"
      ;;
    *)
      echo "Unknown source type: $SRCTYPE"
      return
      ;;
  esac

  echo "Compiling: $COMPILE_CMD"
  system -v "$COMPILE_CMD"
}

echo "$dashes"
echo "Starting Build of ${SRCLIBTEXT} library ${SRCLIB}"

# Add libraries to library list
system -v "ADDLIBLE LIB(${SRCLIB})"
system -v "MONMSG MSGID(CPF0000)"

# Create library, clear library, and create source file 
system -v "CRTLIB ${SRCLIB} TYPE(*PROD) TEXT('${SRCLIBTEXT}')"
system -v "CLRLIB LIB(${SRCLIB})"
system -v "CRTSRCPF FILE(${SRCLIB}/${SRCFILE}) RCDLEN(120) CCSID(${SRCCCSID})"

# Create and set data area for version
VERSION="V1.0.33"
system -v "CRTDTAARA DTAARA(${SRCLIB}/VERSION) TYPE(*CHAR) LEN(30) VALUE('${VERSION}') TEXT('${SRCLIB} version')"
system -v "MONMSG MSGID(CPF0000)"
system -v "CHGDTAARA DTAARA(${SRCLIB}/VERSION) VALUE('${VERSION}')"

# Create and set data area for Python binary location
QSHPYTHON="/qshpython"
system -v "CRTDTAARA DTAARA(${SRCLIB}/PYPATH) TYPE(*CHAR) LEN(255) VALUE('/QOpenSys/pkgs/bin') TEXT('Path to Python Binaries')"

# Create and set data area for QSHONI Python scripts
system -v "CRTDTAARA DTAARA(${SRCLIB}/QSHPYTHON) TYPE(*CHAR) LEN(255) VALUE('${QSHPYTHON}') TEXT('Path to QSHONI Python Scripts')"

# Attempt to create Python script directory
system -v "MKDIR DIR('${QSHPYTHON}') DTAAUT(*RWX) OBJAUT(*ALL)"
system -v "MONMSG MSGID(CPF0000)"

# Create and set data area for PHP binary location
system -v "CRTDTAARA DTAARA(${SRCLIB}/PHPPATH) TYPE(*CHAR) LEN(255) VALUE(' ') TEXT('Path to PHP Binaries')"

# Create and set data area for open source package path location
system -v "CRTDTAARA DTAARA(${SRCLIB}/QSHPATHLOC) TYPE(*CHAR) LEN(10) VALUE('*BEGIN') TEXT('Path position for open source packages')"

# Create and set data area for default IFS save file location
system -v "CRTDTAARA DTAARA(${SRCLIB}/SAVFDIR) TYPE(*CHAR) LEN(255) VALUE('/tmp/savfqsh') TEXT('Path to save file IFS output')"

# Make /tmp/savfqsh directory
system -v "MKDIR DIR('/tmp/savfqsh') DTAAUT(*RWX) OBJAUT(*ALL)"
system -v "MONMSG MSGID(CPF0000)"

# Change library description to match the version
system -v "CHGLIB LIB(${SRCLIB}) TEXT('QShell on IBM i - ${VERSION}')"

# Make /tmp/qsh directory
system -v "MKDIR DIR('/tmp/qsh') DTAAUT(*RWX) OBJAUT(*ALL)"
system -v "MONMSG MSGID(CPF0000)"

declare -A FILES_AND_TEXTS=(
   ["QSHBASH.CMD"]="Run Bash Command via Qshell"
   ["QSHBASHC.CLLE"]="Run Bash Command via Qshell"
   ["QSHEXEC.CMD"]="Run QShell Command Line"
   ["QSHEXECC.CLLE"]="Run QShell Command Line"
   ["QSHLOGSCAC.CLLE"]="Scan Qshell Log File for Value"
   ["QSHLOGSCAN.CMD"]="Scan Qshell Log File for Value"
   ["QSHLOGSCAR.RPGLE"]="Scan Qshell Log File for Value"
   ["QSHPATH.CMD"]="Set Open Source Package Path Environment Variables"
   ["QSHPATHC.CLLE"]="Set Open Source Package Path Environment Variables"
   ["QSHSTDOUTR.RPGLE"]="Read and parse stdout log"
   ["QSHIFSCHKR.RPGLE"]="Check for IFS File Existence"
   ["QSHIFSCHKC.CLLE"]="Check for IFS File Existence"
   ["QSHIFSCHK.CMD"]="Check for IFS File Existence"
   ["QSHPYRUN.CMD"]="Run Python Script via Qshell"
   ["QSHPYRUNC.CLLE"]="Run Python Script via Qshell"
   ["QSHDEMO01R.RPGLE"]="Read Outfile STDOUTQSH and display via DSPLY cmd"
   ["QSHQRYTMP.CMD"]="SQL Query Data to Selected Temp Table with RUNSQL"
   ["QSHQRYTMPC.CLLE"]="SQL Query Data to Selected Temp Table with RUNSQL"
   ["QSHCURL.CMD"]="Run Curl Command via QShell"
   ["QSHCURLC.CLLE"]="Run Curl Command via QShell"
   ["QSHPORTCHK.CMD"]="Check for active TCP/IP Local Port"
   ["QSHPORTCHC.CLLE"]="Check for active TCP/IP Local Port"
   ["QSHPORTEND.CMD"]="End All Jobs for Active TCP/IP Local Port"
   ["QSHPORTENC.CLLE"]="End All Jobs for Active TCP/IP Local Port"
   ["QSHSETPROC.CLLE"]="Set up .profile, .bash_profile and .bashrc files"
   ["QSHSETPROF.CMD"]="Set up .profile, .bash_profile and .bashrc files"
   ["QSHBASHRC.TXT"]="User .bashrc bash template for Opn Src Pkgs"
   ["QSHBASHPRF.TXT"]="User .bash_profile bash template for Opn Src Pkgs"
   ["QSHPROFILE.TXT"]="User QShell .profile template for Opn Src Pkgs"
   ["QSHEXECSRC.CMD"]="Run QShell .sh script from Source File Member"
   ["QSHEXECSCC.CLLE"]="Run QShell .sh script from Source File Member"
   ["QSHBASHSRC.CMD"]="Run Bash .sh script from Source File Member"
   ["QSHBASHSCC.CLLE"]="Run Bash .sh script from Source File Member"
   ["DB2UTIL.CMD"]="Execute db2util Query to IFS File"
)

# Copy source members to file and compile
for CURFILE in "${!FILES_AND_TEXTS[@]}"; do
  SRCTEXT=${FILES_AND_TEXTS[$CURFILE]}
  cpy_member
  compile_member
done

# Create message file and custom CPF messages
system -v "CRTMSGF MSGF(${SRCLIB}/QSHMSG) TEXT('Qshell CPF Messages')"
system -v "ADDMSGD MSGID(QSS9898) MSGF(${SRCLIB}/QSHMSG) MSG('&1.') SECLVL('This message is used to log QSH console feedback messages.') FMT((*CHAR 512)) CCSID(*JOB)"

# Create and set data area for version
VERSION="V1.0.33"
system -v "CRTDTAARA DTAARA(${SRCLIB}/VERSION) TYPE(*CHAR) LEN(30) VALUE('${VERSION}') TEXT('${SRCLIB} version')"
system -v "MONMSG MSGID(CPF0000)"
system -v "CHGDTAARA DTAARA(${SRCLIB}/VERSION) VALUE('${VERSION}')"

# Create and set data area for Python binary location
QSHPYTHON="/qshpython"
system -v "CRTDTAARA DTAARA(${SRCLIB}/PYPATH) TYPE(*CHAR) LEN(255) VALUE('/QOpenSys/pkgs/bin') TEXT('Path to Python Binaries')"

# Create and set data area for QSHONI Python scripts
system -v "CRTDTAARA DTAARA(${SRCLIB}/QSHPYTHON) TYPE(*CHAR) LEN(255) VALUE('${QSHPYTHON}') TEXT('Path to QSHONI Python Scripts')"

# Attempt to create Python script directory
system -v "MKDIR DIR('${QSHPYTHON}') DTAAUT(*RWX) OBJAUT(*ALL)"
system -v "MONMSG MSGID(CPF0000)"

# Create and set data area for PHP binary location
system -v "CRTDTAARA DTAARA(${SRCLIB}/PHPPATH) TYPE(*CHAR) LEN(255) VALUE(' ') TEXT('Path to PHP Binaries')"

# Create and set data area for open source package path location
system -v "CRTDTAARA DTAARA(${SRCLIB}/QSHPATHLOC) TYPE(*CHAR) LEN(10) VALUE('*BEGIN') TEXT('Path position for open source packages')"

# Create and set data area for default IFS save file location
system -v "CRTDTAARA DTAARA(${SRCLIB}/SAVFDIR) TYPE(*CHAR) LEN(255) VALUE('/tmp/savfqsh') TEXT('Path to save file IFS output')"

# Make /tmp/savfqsh directory
system -v "MKDIR DIR('/tmp/savfqsh') DTAAUT(*RWX) OBJAUT(*ALL)"
system -v "MONMSG MSGID(CPF0000)"

# Change library description to match the version
system -v "CHGLIB LIB(${SRCLIB}) TEXT('QShell on IBM i - ${VERSION}')"

# Make /tmp/qsh directory
system -v "MKDIR DIR('/tmp/qsh') DTAAUT(*RWX) OBJAUT(*ALL)"
system -v "MONMSG MSGID(CPF0000)"

echo "Completed Build of ${SRCLIBTEXT} library ${SRCLIB}"
echo "$dashes"
