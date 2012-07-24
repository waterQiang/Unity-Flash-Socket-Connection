using UnityEngine;
using System.Collections;
using System.Net;
using System.Net.Sockets;
using System;
using System.Text;

public class FlashController: MonoBehaviour
{

    public delegate void CommandEvent(String command);
    public event CommandEvent OnCommand;

    public void Execute(String command)
    {
        if (stream != null)
        {
            byte[] data = System.Text.Encoding.UTF8.GetBytes(command + "\n");
            stream.Write(data, 0, data.Length);
        }
    }

    TcpListener socket;
    TcpClient client;
    NetworkStream stream;

    void Start()
    {
        Int32 port = 6001;
        IPAddress localAddr = IPAddress.Parse("192.168.50.214");
        socket = new TcpListener(localAddr, port);
        socket.Start();

        socket.BeginAcceptTcpClient(new AsyncCallback(onConnect), null);
    }

    void Update()
    {

        

        //		if ( stream != null ) {
        //			Byte[] data = System.Text.Encoding.UTF8.GetBytes( "FISH AND CHIPS!!пшаю лнеи леврш!\n" );  
        //			stream.Write( data, 0, data.Length );	
        //		}
        if (stream != null)
        {
            if (client.Available > 0)
            {
                byte[] buffer = new byte[1024];
                StringBuilder message = new StringBuilder();
                int length = 0;

                do
                {
                    length = stream.Read(buffer, 0, buffer.Length);
                    message.AppendFormat("{0}", Encoding.UTF8.GetString(buffer, 0, length));

                } while (stream.DataAvailable);
                Debug.Log("GOT COMMAND " + message.ToString());
                if (OnCommand != null) OnCommand(message.ToString().Replace("\n", ""));
            }
        }
    }

    void OnDestroy()
    {
        socket.Stop();
        if (client != null) client.Close();
    }

    void onConnect(IAsyncResult ar)
    {
        client = socket.EndAcceptTcpClient(ar);
        Debug.Log("Accepted connection!");

        stream = client.GetStream();
    }

}
