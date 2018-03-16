public class PwnedAPI : GLib.Object {
    public signal void start_loading ();
    public signal void end_loading ();

    private Soup.Session session;
    private string base_url;

    construct {
        session = new Soup.Session();
        base_url = "https://api.pwnedpasswords.com/";
    }


    public string check_password (string password) {
        start_loading ();
        var pwned_count = "-1"; //handle this to return int
        var url = "%spwnedpassword/%s".printf(base_url, password);
        var message = new Soup.Message ("GET", url);
        session.send_message (message);
        if (message.status_code == 200) {
            end_loading ();
            pwned_count = (string) message.response_body.flatten ().data; // if I cast this to int, it acts weird, check this.
        }
        end_loading ();
        return pwned_count;
    }
}
