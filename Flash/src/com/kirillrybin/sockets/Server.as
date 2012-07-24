﻿package com.kirillrybin.sockets {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	public class Server extends Sprite {
		private var serverSocket : ServerSocket = new ServerSocket();
		private var clientSocket : Socket;
		private var localIP : TextField;
		private var localPort : TextField;
		private var logField : TextField;
		private var message : TextField;

		public function Server() {
			// Launch your application by right clicking within this class and select: Debug As > FDT SWF Application
			setupUI();
		}

		private function onConnect(event : ServerSocketConnectEvent) : void {
			clientSocket = event.socket;
			clientSocket.addEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
			log("Connection from " + clientSocket.remoteAddress + ":" + clientSocket.remotePort);
		}

		private function onClientSocketData(event : ProgressEvent) : void {
			var buffer : ByteArray = new ByteArray();
			clientSocket.readBytes(buffer, 0, clientSocket.bytesAvailable);
			log("Received: " + buffer.toString());
			
		}

		private function bind(event : Event) : void {
			if ( serverSocket.bound ) {
				serverSocket.close();
				serverSocket = new ServerSocket();
			}
			serverSocket.bind(parseInt(localPort.text), localIP.text);
			serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
			serverSocket.listen();
			log("Bound to: " + serverSocket.localAddress + ":" + serverSocket.localPort);
		}

		private function send(event : Event) : void {
			try {
				if ( clientSocket != null && clientSocket.connected ) {
					clientSocket.writeUTFBytes(message.text);
					clientSocket.flush();
					log("Sent message to " + clientSocket.remoteAddress + ":" + clientSocket.remotePort);
				} else log("No socket connection.");
			} catch ( error : Error ) {
				log(error.message);
			}
		}

		private function log(text : String) : void {
			logField.appendText(text + "\n");
			logField.scrollV = logField.maxScrollV;
			trace(text);
		}

		private function setupUI() : void {
			localIP = createTextField(10, 10, "Local IP", "192.168.50.214");
			localPort = createTextField(10, 35, "Local port", "6001");
			createTextButton(170, 60, "Bind", bind);
			message = createTextField(10, 85, "Message", "Lucy can't drink milk.");
			createTextButton(170, 110, "Send", send);
			logField = createTextField(10, 135, "Log", "", false, 200)

			this.stage.nativeWindow.activate();
		}

		private function createTextField(x : int, y : int, label : String, defaultValue : String = '', editable : Boolean = true, height : int = 20) : TextField {
			var labelField : TextField = new TextField();
			labelField.text = label;
			labelField.type = TextFieldType.DYNAMIC;
			labelField.width = 100;
			labelField.x = x;
			labelField.y = y;

			var input : TextField = new TextField();
			input.text = defaultValue;
			input.type = TextFieldType.INPUT;
			input.border = editable;
			input.selectable = editable;
			input.width = 280;
			input.height = height;
			input.x = x + labelField.width;
			input.y = y;

			this.addChild(labelField);
			this.addChild(input);

			return input;
		}

		private function createTextButton(x : int, y : int, label : String, clickHandler : Function) : TextField {
			var button : TextField = new TextField();
			button.htmlText = "<u><b>" + label + "</b></u>";
			button.type = TextFieldType.DYNAMIC;
			button.selectable = false;
			button.width = 180;
			button.x = x;
			button.y = y;
			button.addEventListener(MouseEvent.CLICK, clickHandler);

			this.addChild(button);
			return button;
		}
	}
}
