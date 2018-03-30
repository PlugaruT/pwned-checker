 /*-
 * Copyright (c) 2018 Tudor Plugaru (https://github.com/PlugaruT/pwned-checker)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 *
 * Authored by: Tudor Plugaru <plugaru.tudor@gmail.com>
 */


public class PwnedAPI : GLib.Object {
    public signal void start_loading ();
    public signal void end_loading ();

    private string base_url;

    construct {
        base_url = "https://api.pwnedpasswords.com/";
    }


    public string check_password (string password) {
        start_loading ();
        var session = new Soup.Session();
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

    public int check_account (string email) {
        start_loading ();
        var session = new Soup.Session();
        var counter = 0;

        var url = "https://haveibeenpwned.com/api/v2/breachedaccount/%s".printf(email);
        warning (url);
        var message = new Soup.Message ("GET", url);
        session.send_message (message);
        warning ("here");
        warning ("%u".printf(message.status_code));

        if (message.status_code == 200) {
            end_loading ();
            warning ("message ok");
            try {
                warning ("here %s".printf((string)message.response_body.flatten ()));
                var parser = new Json.Parser();
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);
                warning ((string)message.response_body.flatten ());
                var root_object = parser.get_root ().get_object();


            } catch (Error e) {
                warning ("Failed to connect to service: %s", e.message);
            }
        } else {
            warning ("not ok");
        }
        return counter;
    }
}





























