# archive
echo
echo "============= build archive : Begin ============="

AutoBuildToIPA_SchemeName="Website"
AutoBuildToIPA_ConfigurationType="Release"
AutoBuildToIPA_Explanation=""
AutoBuildToIPA_OptionsPlist_SrcFile="ipaExportOptionsPlist"
AutoBuildToIPA_OptionsPlist_BundleIdentifier=(tw.com.taiwantaxi)
AutoBuildToIPA_OptionsPlist_ProvisionProfile=(Website_Distribution)

AutoBuildToIPA_BundleShortVersion="1.0"
AutoBuildToIPA_IPAFolderName="SCM/Output/"
AutoBuildToIPA_OptionsPlist_Method="app-store"

DateLog=`date +"%Y_%m_%d_%HHr%MMin"`

if [[ $AutoBuildToIPA_Explanation == "" ]]; then
	# AutoBuildToIPA_BuildName="Output/$AutoBuildToIPA_SchemeName/$AutoBuildToIPA_SchemeName-$AutoBuildToIPA_ConfigurationType-V$AutoBuildToIPA_BundleShortVersion.$SvnVersion-$DateLog"
	AutoBuildToIPA_BuildName="Output/$AutoBuildToIPA_SchemeName/$AutoBuildToIPA_SchemeName-$AutoBuildToIPA_ConfigurationType-V$AutoBuildToIPA_BundleShortVersion-$DateLog"
else
	# AutoBuildToIPA_BuildName="Output/$AutoBuildToIPA_SchemeName/$AutoBuildToIPA_SchemeName-$AutoBuildToIPA_ConfigurationType-V$AutoBuildToIPA_BundleShortVersion.$SvnVersion-$AutoBuildToIPA_Explanation-$DateLog"
	AutoBuildToIPA_BuildName="Output/$AutoBuildToIPA_SchemeName/$AutoBuildToIPA_SchemeName-$AutoBuildToIPA_ConfigurationType-V$AutoBuildToIPA_BundleShortVersion-$AutoBuildToIPA_Explanation-$DateLog"
fi

AutoBuildToIPA_ArchiveFullName=$AutoBuildToIPA_BuildName".xcarchive"

AutoBuildToIPA_BuildCommand="-workspace Website.xcworkspace -scheme $AutoBuildToIPA_SchemeName -configuration $AutoBuildToIPA_ConfigurationType ONLY_ACTIVE_ARCH=NO -archivePath $AutoBuildToIPA_BuildName archive"
# AutoBuildToIPA_BuildCommand="-project $AutoBuildToIPA_WorkspaceFullName -scheme $AutoBuildToIPA_SchemeName -configuration $AutoBuildToIPA_ConfigurationType ONLY_ACTIVE_ARCH=NO -archivePath $AutoBuildToIPA_BuildName archive"

echo "$AutoBuildToIPA_Title_Log AutoBuildToIPA_BuildCommand: $AutoBuildToIPA_BuildCommand"
xcodebuild ${AutoBuildToIPA_BuildCommand}

if [ $? -ne 0 ]; then
	echo "xcodebuild ${AutoBuildToIPA_BuildCommand} ... fail !!!"
	exit 1
fi

echo "$AutoBuildToIPA_Title_Log ============= build archive : End ============="
echo 

sleep 0.01

# deal ExportOptionsPlist 內容.
AutoBuildToIPA_OptionsPlist_File=${AutoBuildToIPA_OptionsPlist_SrcFile}.plist

cp ${WORKSPACE}/SCM/${AutoBuildToIPA_OptionsPlist_SrcFile}.templete.plist ${WORKSPACE}/SCM/${AutoBuildToIPA_OptionsPlist_File}
/usr/libexec/PlistBuddy -c "Set :method ${AutoBuildToIPA_OptionsPlist_Method}" "${WORKSPACE}/SCM/${AutoBuildToIPA_OptionsPlist_File}"
/usr/libexec/PlistBuddy -c "Add :provisioningProfiles:${AutoBuildToIPA_OptionsPlist_BundleIdentifier} string ${AutoBuildToIPA_OptionsPlist_ProvisionProfile}" "${WORKSPACE}/SCM/${AutoBuildToIPA_OptionsPlist_File}"

# ipa
echo
echo "$AutoBuildToIPA_Title_Log ============= generator ipa : Begin ============="

AutoBuildToIPA_ExportIPACommand="-exportArchive -archivePath ${AutoBuildToIPA_ArchiveFullName} -exportPath ${AutoBuildToIPA_IPAFolderName} -exportOptionsPlist ${WORKSPACE}/SCM/${AutoBuildToIPA_OptionsPlist_File} -allowProvisioningUpdates"

echo "xcodebuild ${AutoBuildToIPA_ExportIPACommand}"

xcodebuild ${AutoBuildToIPA_ExportIPACommand}

if [ $? -ne 0 ]; then
	echo "xcodebuild ${AutoBuildToIPA_ExportIPACommand} ... fail !!!"
	exit 1
fi

echo "$AutoBuildToIPA_Title_Log ============= generator ipa : End ============="
echo 