using System.Text;
using System.Net;
using System.Net.Sockets;

namespace MessageAppServer
{
    class Program
    {
        static TcpListener listener = new TcpListener(IPAddress.Any, 5000);
        static List<TcpClient> clients = new List<TcpClient>();
        static object lockObj = new object();

        static void Main(string[] args)
        {
            listener.Start();

            Task.Run(async () =>
            {
                while (true)
                {
                    var client = listener.AcceptTcpClient();
                    lock (lockObj)
                    {
                        clients.Add(client);
                    }

                    HandleClient(client);
                }
            });

            Console.ReadKey();
        }

        static void HandleClient(TcpClient client)
        {
            Task.Run(async () =>
            {
                try
                {
                    var stream = client.GetStream();
                    var buffer = new byte[client.ReceiveBufferSize];

                    while (true)
                    {
                        var bytesRead = await stream.ReadAsync(buffer, 0, buffer.Length);
                        if (bytesRead == 0) break;  // Client disconnected

                        var message = Encoding.ASCII.GetString(buffer, 0, bytesRead);
                        Console.WriteLine($"Received request: {message}");

                        // Send a response
                        var response = Encoding.ASCII.GetBytes(message);
                        await stream.WriteAsync(response, 0, response.Length);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error: {ex.Message}");
                }
                finally
                {
                    client.Close();
                    lock (lockObj)
                    {
                        clients.Remove(client);
                    }
                }
            });
        }
    }
}
