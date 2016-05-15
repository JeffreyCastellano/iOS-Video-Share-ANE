# iOS-Video-Share-ANE Summary

This ANE for iOS 7(?) and higher lets you share local videos (no web URLs!) to native apps like SMS, Mail and CameraRoll. In addition it supports Facebook sharing, Facebook Messenger sharing, and Instagram integration. This works without using the Document Interaction API. That API is great but sometimes you need to share directly to apps or want to skip the middle man process of loading yet another view before you get to where you need to go. This library can easily be adapted for images, urls, full Facebook use, etc but right now is focused on just video.


#Warning

This library is functioning but is missing a lot of error handling and easy to add features. Should be fine for normal use but needs a little extra love when handling.


#Simple Example 

```actionscript

	import com.empath.extensions.social.EmpathVideoShareExtension;
	
	public class Main extends MovieClip {
		
		private var videoShareExt = new EmpathVideoShareExtension();
		private var videoFile = File.applicationDirectory.resolvePath( "videos/Test_Video.mp4");
		
		videoShareExt.composeSMS("Test Message","",[videoFile.nativePath+"|native|video/mp4|Video_Test"]);
		
		videoShareExt.composeMail("Hello", "<html><body><p>Hi,</p></br><p>This is a test message.</body></html>","test@email.com",[videoFile.nativePath+"|native|mp4|Video_Test"]);
		
		videoShareExt.composeFacebook("Test FB",[videoFile.nativePath+"|native|video/mp4|Video_Test"]);
		
		videoShareExt.composeMessenger("Test FB",[videoFile.nativePath+"|native|video/mp4|Video_Test"]);
		
		videoShareExt.saveVideoToCameraRoll([videoFile.nativePath+"|native|video/mp4|Video_Test"]);
		
		videoShareExt.composeInstagram([videoFile.nativePath+"|native|video/mp4|Video_Test"]);
```

#Facebook

Facebook integration requires a FB app ID. It's easy to make :) https://developers.facebook.com/apps/ Then add replace your app ID where appropriate below. The following XML must be added to your AIR output. See the Sample file for placement.

	
	<key>CFBundleURLTypes</key>
		<array>
  		<dict>
    	<key>CFBundleURLSchemes</key>
    	<array>
      	<string>fb266977876984377</string>
   		</array>
  		</dict>
		</array>
		<key>FacebookAppID</key>
		<string>266977876984377</string>
		<key>FacebookDisplayName</key>
		<string>Wingman</string>
		<key>LSApplicationQueriesSchemes</key>
		<array>
  		<string>fbapi</string>
  		<string>fb-messenger-api</string>
  		<string>fbauth2</string>
  		<string>fbshareextension</string>
		</array>
