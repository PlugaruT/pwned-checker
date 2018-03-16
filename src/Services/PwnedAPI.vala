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
