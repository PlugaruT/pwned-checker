public class PwnedAPI : GLib.Object {
    private Soup.Session session;
    construct {
        session = new Soup.Session();
    }


    public bool check_password (string password) {
        var is_pwned = false;
        var url = "https://api.pwnedpasswords.com/pwnedpassword/%s".printf(password);
        var message = new Soup.Message("GET", url);
        session.send_message (message);
        if (message.status_code == 200) {
            is_pwned = true;
        }
        return is_pwned;
    }

    public void check_email (string email) {

    }
}
