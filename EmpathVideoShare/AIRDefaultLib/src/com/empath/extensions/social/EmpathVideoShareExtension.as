package com.empath.extensions.social
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	public class EmpathVideoShareExtension extends EventDispatcher
	{
		private static const EXTENSION_ID : String = "com.empath.extensions.social";
		public static const ERROR : String = "ERROR";
		
		
		public function EmpathVideoShareExtension( _target : IEventDispatcher = null )
		{
			super( _target );
		}
		
		
		
		public function composeMail(subject:String, messageBody:String, toRecipients:String,attachmentsData:Array = null) : void
		{
			trace("open compose Mail when installed on iOS"); 
		}
		
		public function composeSMS(messageBody:String="", toRecipients:String="", attachmentsData:Array = null) : void
		{
			trace("open compose SMS when installed on iOS"); 
		}
		
		public function composeFacebook(messageBody:String="", attachmentsData:Array = null) : void
		{
			trace("open compose Facebook Composer when installed on iOS"); 
		}
		
		public function composeMessenger(messageBody:String="", attachmentsData:Array = null) : void
		{
			trace("open compose FB Messenger Composer when installed on iOS"); 
		}
		
		public function saveVideoToCameraRoll(attachmentsData:Array = null) : void
		{
			trace("save to camera roll when installed on iOS"); 
		}
		
		public function composeInstagram(attachmentsData:Array = null) : void
		{
			trace("open compose Instagram Composer when installed on iOS"); 
		}
		
	}
}