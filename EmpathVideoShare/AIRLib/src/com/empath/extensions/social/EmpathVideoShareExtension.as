package com.empath.extensions.social
{
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	
	public class EmpathVideoShareExtension extends EventDispatcher
	{
		public static const ERROR : String = "ERROR";
		
		
		public function EmpathVideoShareExtension( _target : IEventDispatcher = null )
		{
			super( _target );
			ensureContext();
		}
		
		
		
		public function composeMail(subject:String, messageBody:String, toRecipients:String,attachmentsData:Array = null) : void
		{
			m_extContext.call( "composeMail", subject, messageBody, toRecipients, attachmentsData );
		}
		
		public function composeSMS(messageBody:String="", toRecipients:String="", attachmentsData:Array = null) : void
		{
			m_extContext.call( "composeSMS",messageBody,toRecipients, attachmentsData );
		}
		
		public function composeFacebook(messageBody:String="", attachmentsData:Array = null) : void
		{
			m_extContext.call( "composeFacebook",messageBody, attachmentsData );
		}
		
		public function composeMessenger(messageBody:String="", attachmentsData:Array = null) : void
		{
			m_extContext.call( "composeMessenger",messageBody, attachmentsData );
		}
		
		public function saveVideoToCameraRoll(attachmentsData:Array = null) : void
		{
			m_extContext.call( "saveVideoToCameraRoll", attachmentsData );
		}
		
		public function composeInstagram(attachmentsData:Array = null) : void
		{
			m_extContext.call( "sendInstagram", attachmentsData );
		}
		
		
		/** 
		 * Destructor
		 */
		public function dispose() : void 
		{
			if ( null != m_extContext )
			{	
				m_extContext.removeEventListener( StatusEvent.STATUS, onStatusEvent );
				m_extContext.dispose();
			}
		}
		
		
		private function ensureContext() : void	
		{
			if ( null == m_extContext )
			{
				try
				{
					m_extContext = ExtensionContext.createExtensionContext( EXTENSION_ID, null );
					
					m_extContext.removeEventListener( StatusEvent.STATUS, onStatusEvent );
					m_extContext.addEventListener( StatusEvent.STATUS, onStatusEvent );
				}
				catch ( error : ArgumentError )
				{
					dispatchEvent( new DataEvent( ERROR, "Error: " + error.toString() ) );
				}
			}
		}
		
		
		private function onStatusEvent( _event : StatusEvent ) : void
		{
		}
		
		
		private var m_extContext 	: ExtensionContext = null;
		private static const EXTENSION_ID : String = "com.empath.extensions.social";
	}
}

















































