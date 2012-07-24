package com.kirillrybin.sockets {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Z68
	 */
	public class Client extends Sprite {
		
		private var socket:CustomSocket;
		
		public function Client() {
			socket = new CustomSocket("192.168.50.214", 6001);
			socket.addEventListener(Event.CONNECT, connectHandler);
		}

		private function connectHandler(event : Event) : void {
			var btnSend:Sprite = new Sprite();
			btnSend.buttonMode = true;
			btnSend.graphics.beginFill(0x00ff00);
			btnSend.graphics.drawRect(0, 0, 200, 200);
			btnSend.graphics.endFill();
			btnSend.addEventListener(MouseEvent.CLICK, send);
			addChild(btnSend);
		}

		private function send(event : MouseEvent) : void {
			socket.send("Привет Unity3D!");
		}
		
		
		
	}
}
import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;

class CustomSocket extends Socket {
    private var response:String;

    public function CustomSocket(host:String = null, port:uint = 0) {
        super();
        configureListeners();
        if (host && port)  {
            super.connect(host, port);
        }
    }

    private function configureListeners():void {
        addEventListener(Event.CLOSE, closeHandler);
        addEventListener(Event.CONNECT, connectHandler);
        addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
    }

    private function writeln(str:String):void {
        str += "\n";
        try {
            writeUTFBytes(str);
        }
        catch(e:IOError) {
            trace(e);
        }
	}

	public function send(string : String) : void {
		
		response = "";
        writeln(string);
        flush();
	}

    private function sendRequest():void {
        trace("sendRequest");
        response = "";
        writeln("GET /");
        flush();
    }

    private function readResponse():void {
        var str:String = readUTFBytes(bytesAvailable);
        response += str;
    }

    private function closeHandler(event:Event):void {
        trace("closeHandler: " + event);
        trace(response.toString());
    }

    private function connectHandler(event:Event):void {
        trace("connectHandler: " + event);
        sendRequest();
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
        trace("ioErrorHandler: " + event);
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
        trace("securityErrorHandler: " + event);
    }

    private function socketDataHandler(event:ProgressEvent):void {
        trace("socketDataHandler: " + event);
        readResponse();
    }
}