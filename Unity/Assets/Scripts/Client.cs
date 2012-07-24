using UnityEngine;
using System.Collections;
using System.Net.Sockets;
using System.Net;


public class Client : MonoBehaviour {
    
    public string m_IPAdress = "127.0.0.1";
    public string kPort = "6001";

    private static Client singleton;

    
    private Socket m_Socket;
    void Awake ()
    {
        m_Socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
    }
    
    void OnApplicationQuit ()
    {
        m_Socket.Close();
        m_Socket = null;
    }

    private string dataToSend = "Hello Flash!";

    void OnGUI() {

        bool connected = m_Socket.Connected;

        if (connected){


            dataToSend = GUILayout.TextField(dataToSend, 25);
            if (GUILayout.Button("Œ“œ–¿¬»“‹"))
            {
                byte[] data = System.Text.Encoding.UTF8.GetBytes( dataToSend + "\n" );
                m_Socket.Send(data);
            }
                                    
        } else {

            GUILayout.BeginHorizontal();
            GUILayout.Label("IP ¿ƒ–≈—");
            m_IPAdress = GUILayout.TextField(m_IPAdress, 25);
            GUILayout.EndHorizontal();
            GUILayout.BeginHorizontal();
            GUILayout.Label("œŒ–“");
            kPort = GUILayout.TextField(kPort, 25);
            GUILayout.EndHorizontal();

            if (GUILayout.Button("œŒƒ Àﬁ◊»“‹—ﬂ"))
            {
            
                System.Net.IPAddress remoteIPAddress = System.Net.IPAddress.Parse(m_IPAdress);

                System.Net.IPEndPoint remoteEndPoint = new System.Net.IPEndPoint(remoteIPAddress, int.Parse(kPort));

                singleton = this;
                m_Socket.Connect(remoteEndPoint);
            
            }
        }

        
    }
    
    
}