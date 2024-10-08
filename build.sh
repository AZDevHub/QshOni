
#!/QOpenSys/usr/bin/qsh
#----------------------------------------------------------------
# Script name: build.sh
# Author: Richard Schoen
# Purpose: Create QSHONI library, copies source members and compiles objects
#----------------------------------------------------------------
SRCLIB="QSHONI"
SRCLIBTEXT="QShell on IBM i"
SRCFILE="SOURCE"
SRCCCSID="37"
dashes="---------------------------------------------------------------------------"

function cpy_member
{
# ----------------------------------------------------------------
# Copy source member and set source type
# ----------------------------------------------------------------
  SRCMEMBER=`echo "${CURFILE^^}" | cut -d'.' -f1`  # Parse PC file name prefix to member name
  SRCTYPE=`echo "${CURFILE^^}" | cut -d'.' -f2`    # Parse PC file name extenstion to souce type
  system -v "CPYFRMSTMF FROMSTMF('${PWD}/${CURFILE}') TOMBR('/QSYS.LIB/${SRCLIB}.LIB/${SRCFILE}.FILE/${SRCMEMBER}.MBR') MBROPT(*REPLACE) DBFCCSID(*FILE)"
  system -v "CHGPFM FILE(${SRCLIB}/${SRCFILE}) MBR($SRCMEMBER) SRCTYPE(${SRCTYPE}) TEXT('${SRCTEXT}')" 
}

echo "$dashes"
echo "Starting Build of ${SRCLIBTEXT} library ${SRCLIB}"

# Create library, clear library and create source file 
system -v "CRTLIB ${SRCLIB} TYPE(*PROD) TEXT('${SRCLIBTEXT}')"
system -v "CLRLIB LIB(${SRCLIB})"
system -v "CRTSRCPF FILE(${SRCLIB}/${SRCFILE}) RCDLEN(120) CCSID(${SRCCCSID})"

# Copy all the source members and set source types
CURFILE="QSHBASH.CMD"
SRCTEXT="Run Bash Command via Qshell"
cpy_member

CURFILE="QSHBASHC.CLLE"              
SRCTEXT="Run Bash Command via Qshell"                            
cpy_member

CURFILE="QSHEXEC.CMD"                
SRCTEXT="Run QShell Command Line"                          
cpy_member

CURFILE="QSHEXECC.CLLE"
SRCTEXT="Run QShell Command Line"
cpy_member

CURFILE="QSHLOGSCAC.CLLE"
SRCTEXT="Scan Qshell Log File for Value"  
cpy_member

CURFILE="QSHLOGSCAN.CMD"
SRCTEXT="Scan Qshell Log File for Value"
cpy_member

CURFILE="QSHLOGSCAR.RPGLE"
SRCTEXT="Scan Qshell Log File for Value"
cpy_member

CURFILE="QSHPATH.CMD"
SRCTEXT="Set Open Source Package Path Environment Variables"
cpy_member

CURFILE="QSHPATHC.CLLE"
SRCTEXT="Set Open Source Package Path Environment Variables"
cpy_member

CURFILE="QSHSTDOUTR.RPGLE"
SRCTEXT="Read and parse stdout log"
cpy_member

CURFILE="QSHIFSCHKR.RPGLE"
SRCTEXT="Check for IFS File Existence"
cpy_member

CURFILE="QSHIFSCHKC.CLLE"
SRCTEXT="Check for IFS File Existence"
cpy_member

CURFILE="QSHIFSCHK.CMD"
SRCTEXT="Check for IFS File Existence"
cpy_member

CURFILE="QSHPYRUN.CMD"
SRCTEXT="Run Python Script via Qshell"
cpy_member

CURFILE="QSHPYRUNC.CLLE"
SRCTEXT="Run Python Script via Qshell"
cpy_member

CURFILE="QSHDEMO01R.RPGLE"
SRCTEXT="Read Outfile STDOUTQSH and display via DSPLY cmd"
cpy_member

CURFILE="QSHQRYTMP.CMD"
SRCTEXT="SQL Query Data to Selected Temp Table with RUNSQL"
cpy_member

CURFILE="QSHQRYTMPC.CLLE"
SRCTEXT="SQL Query Data to Selected Temp Table with RUNSQL"
cpy_member

CURFILE="QSHCURL.CMD"
SRCTEXT="Run Curl Command via QShell"
cpy_member

CURFILE="QSHCURLC.CLLE"
SRCTEXT="Run Curl Command via QShell"
cpy_member

CURFILE="QSHPORTCHK.CMD"
SRCTEXT="Check for active TCP/IP Local Port"
cpy_member

CURFILE="QSHPORTCHC.CLLE"
SRCTEXT="Check for active TCP/IP Local Port"
cpy_member

CURFILE="QSHPORTEND.CMD"
SRCTEXT="End All Jobs for Active TCP/IP Local Port"
cpy_member

CURFILE="QSHPORTENC.CLLE"
SRCTEXT="End All Jobs for Active TCP/IP Local Port"
cpy_member

CURFILE="QSHSETPROC.CLLE"
SRCTEXT="Set up .profile, .bash_profile and .bashrc files"
cpy_member

CURFILE="QSHSETPROF.CMD"
SRCTEXT="Set up .profile, .bash_profile and .bashrc files"
cpy_member

CURFILE="QSHBASHRC.TXT"
SRCTEXT="User .bashrc bash template for Opn Src Pkgs"
cpy_member

CURFILE="QSHBASHPRF.TXT"
SRCTEXT="User .bash_profile bash template for Opn Src Pkgs"
cpy_member

CURFILE="QSHPROFILE.TXT"
SRCTEXT="User QShell .profile template for Opn Src Pkgs"
cpy_member

CURFILE="QSHEXECSRC.CMD"                
SRCTEXT="Run QShell .sh script from Source File Member"
cpy_member

CURFILE="QSHEXECSCC.CLLE"
SRCTEXT="Run QShell .sh script from Source File Member"
cpy_member

CURFILE="QSHBASHSRC.CMD"                
SRCTEXT="Run Bash .sh script from Source File Member"
cpy_member

CURFILE="QSHBASHSCC.CLLE"
SRCTEXT="Run Bash .sh script from Source File Member"
cpy_member

CURFILE="DB2UTIL.CMD"                
SRCTEXT="Execute db2util Query to IFS Output File via bash"
cpy_member

CURFILE="DB2UTILC.CLLE"
SRCTEXT="Execute db2util Query to IFS Output File via bash"
cpy_member

CURFILE="QSHPYCALL.CMD"
SRCTEXT="Run Python Script via Qshell and Return Parms"
cpy_member

CURFILE="QSHPYCALLC.CLLE"
SRCTEXT="Run Python Script via Qshell and Return Parms"
cpy_member

CURFILE="QSHPYCALLT.CLLE"
SRCTEXT="Test Call to QSHPYCALL"
cpy_member

CURFILE="QSHGETPARM.CMD"
SRCTEXT="Scan Qshell Log File for Parameter Values"
cpy_member

CURFILE="QSHGETPARR.RPGLE"
SRCTEXT="Run Python Script via Qshell and Return Parms"
cpy_member

CURFILE="QSHPHPRUN.CMD"
SRCTEXT="Run PHP Script via QShell"
cpy_member

CURFILE="QSHPHPRUNC.CLLE"
SRCTEXT="Run PHP Script via QShell"
cpy_member

CURFILE="QSHCALL.CMD"
SRCTEXT="Run QShell Command Line and Return Parms"
cpy_member

CURFILE="QSHCALLC.CLLE"
SRCTEXT="Run QShell Command Line and Return Parms"
cpy_member

CURFILE="QSHCALLT.CLLE"
SRCTEXT="Test Call to QSHCALL"
cpy_member

CURFILE="QSHCALLT.CLLE"
SRCTEXT="Test Call to QSHCALL"
cpy_member

CURFILE="QSHCPYSRC.CMD"
SRCTEXT="Copy Source Member to IFS File"
cpy_member

CURFILE="QSHCPYSRCC.CLLE"
SRCTEXT="Copy Source Member to IFS File"
cpy_member

CURFILE="QSHONISRV.RPGLE"
SRCTEXT="QShell on i - Wrapper Service Program"
cpy_member

CURFILE="QSHONISRVH.RPGLE"
SRCTEXT="QShell on i - Wrapper Service Program - Include"
cpy_member

CURFILE="QSHONISRVD.BNDDIR"
SRCTEXT="QShell on i - Wrapper Service Program-Bind Source"
cpy_member

CURFILE="QSHONIPR01.RPGLE"
SRCTEXT="QSHONISRV Service Program Tester 1 - QSHEXEC"
cpy_member

CURFILE="QSHONIPR02.RPGLE"
SRCTEXT="QSHONISRV Service Program Tester 2 - QSHBASH"
cpy_member

CURFILE="QSHONIPR03.RPGLE"
SRCTEXT="QSHONISRV Service Program Tester 3 - QSHCALL"
cpy_member

CURFILE="QSHIFSSIZ.CMD"
SRCTEXT="Retrieve IFS Object Size using stat64"
cpy_member

CURFILE="QSHIFSSIZC.CLLE"
SRCTEXT="Retrieve IFS Object Size using stat64"
cpy_member

CURFILE="QSHQRYSRC.CMD"
SRCTEXT="SQL Query Data via SQL Source Member to Temp Table"
cpy_member

CURFILE="QSHQRYSRCC.CLLE"
SRCTEXT="SQL Query Data via SQL Source Member to Temp Table"
cpy_member

CURFILE="QSHQRYSRCR.RPGLE"
SRCTEXT="SQL Query Data via SQL Source Member to Temp Table"
cpy_member

CURFILE="QSHSAVLIB.CMD"
SRCTEXT="Save Library to IFS Save File"
cpy_member

CURFILE="QSHSAVLIBC.CLLE"
SRCTEXT="Save Library to IFS Save File"
cpy_member

CURFILE="QSHSAVIFS.CMD"
SRCTEXT="Save IFS Objects to IFS Save File"
cpy_member

CURFILE="QSHSAVIFSC.CLLE"
SRCTEXT="Save IFS Objects to IFS Save File"
cpy_member

CURFILE="SRCBLDC.CLLE"
SRCTEXT="Build cmds from QSHONI/SOURCE file"   
cpy_member

CURFILE="SQLTEST1.SQL"
SRCTEXT="SQL Test 1 - Query Qcustcdt - All Records"   
cpy_member

CURFILE="SQLTEST2.SQL"
SRCTEXT="SQL Test 2 - Query Qcustcdt - Cusnum = 938472"   
cpy_member

CURFILE="README.TXT"
SRCTEXT="Read Me Docs on Setup"
cpy_member

CURFILE="VERSION.TXT"
SRCTEXT="Version Notes"
cpy_member

# Create and run build program
system -q "CRTBNDCL PGM(${SRCLIB}/SRCBLDC) SRCFILE(${SRCLIB}/${SRCFILE}) REPLACE(*YES)"
system -v "CALL PGM(${SRCLIB}/SRCBLDC)"

echo "${SRCLIBTEXT} library ${SRCLIB} was created and programs compiled."
echo "$dashes"
  
