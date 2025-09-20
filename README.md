# **README**
These are my personal scripts to make doing a clean installation of Windows easier. It keeps my work environment in one place that is easy to keep track of and manage. I kept it public as it may be useful to other people.

## **WARNING: These scripts temporarily change the execution policy of your computer. Below is a relevant excerpt from the GNU General Public License used in this software:**
For the protection of both the developer and the author, the GPL clearly states that there is no warranty for this free software. To protect both the user and the author, the GPL requires that modified versions be marked as such, so that any issues are not erroneously attributed to the authors of previous versions.

## How to use these scripts:
First:
Attempt running the script.
If it does not run, try:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser 

Second:
Execute InstallSoftware.ps1 script.

Third:
Install software not available in winget, such as vcpkg. The InstallSoftware.ps1 in the testing repo should automatically prompt you to install VCPKG to "~/Documents", but I have not tested it. 

Fourth:
Install all other dependencies, such as Win SDK using Visual Studio Installer.

Fifth:
Set VCPKG_ROOT environment variable. Ensure it's added to path. Make sure CMAKE installer correctly added CMAKE to path. 


