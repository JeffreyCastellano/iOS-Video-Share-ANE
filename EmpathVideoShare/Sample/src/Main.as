package  {
	
		
	import com.empath.extensions.social.EmpathVideoShareExtension;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	
	
	public class Main extends MovieClip {
		
		private var videoShareExt:EmpathVideoShareExtension = null;
		private var videoFile;
		
		public function Main() {
			
			videoShareExt = new EmpathVideoShareExtension();
					
			socialMenu.shareMailBtn.addEventListener(MouseEvent.CLICK, composeMailClick);
			socialMenu.shareMessageBtn.addEventListener(MouseEvent.CLICK, composeSMSClick);
			socialMenu.shareFacebookBtn.addEventListener(MouseEvent.CLICK, composeFBClick);
			socialMenu.shareMessengerBtn.addEventListener(MouseEvent.CLICK, composeMessengerClick);
			socialMenu.shareSaveBtn.addEventListener(MouseEvent.CLICK, saveVideoClick);
			socialMenu.shareInstagramBtn.addEventListener(MouseEvent.CLICK, composeInstagramClick);
			
			videoFile = File.applicationDirectory.resolvePath( "videos/Test_Video.mp4");
		}
		
	
		// INFO --- //---- attachmentsData is an array of strings: ['File.nativePath|native|mimetype|display_name_of_attachment'] or ['File.nativePath|native|mimetype|display_name_of_attachment','File.nativePath|native|mimetype|display_name_of_attachment'] for multiple attachments
		
		
		protected function composeSMSClick(event:MouseEvent):void{
			videoShareExt.composeSMS("Test Message","",[videoFile.nativePath+"|native|video/mp4|Video_Test"]);
		}
		
		protected function composeMailClick(event:MouseEvent):void{

			videoShareExt.composeMail("Hello", "<html><body><p>Hi,</p></br><p>This is a test message.</body></html>", 
				"test@email.com",//to
				[videoFile.nativePath+"|native|mp4|Video_Test"]); //attachments
		}
		
		private function composeFBClick(e:MouseEvent):void{
			videoShareExt.composeFacebook("Test FB",[videoFile.nativePath+"|native|video/mp4|Video_Test"]);
		}
		
		private function composeMessengerClick(e:MouseEvent):void{
			videoShareExt.composeMessenger("Test FB",[videoFile.nativePath+"|native|video/mp4|Video_Test"]);
		}
		
		private function saveVideoClick(e:MouseEvent):void{
			videoShareExt.saveVideoToCameraRoll([videoFile.nativePath+"|native|video/mp4|Video_Test"]);
		}
		
		private function composeInstagramClick(e:MouseEvent):void{
			videoShareExt.composeInstagram([videoFile.nativePath+"|native|video/mp4|Video_Test"]);
		}
		
			
	}
	
}




