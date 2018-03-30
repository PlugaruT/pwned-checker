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
    public Soup.Session session;

    private string base_url;

    construct {
        session = new Soup.Session ();
        session.user_agent = "com.github.plugarut.pwned-checker";
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

    public string check_account (string email) {
        start_loading ();
        var response = "-1";

        var url = "https://haveibeenpwned.com/api/v2/breachedaccount/%s?truncateResponse=true".printf(email);
        var message = new Soup.Message ("GET", url);
        session.send_message (message);

        if (message.status_code == 200) {
            end_loading ();
            var parser = new Json.Parser();
            try {
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);
            } catch (Error e) {
                warning ("Failed to connect to service: %s", e.message);
            }

            var root = parser.get_root ();
            var array = root.get_array ();
            response = array.get_length ().to_string ();
            /*
            for (var i = 0; i < array.get_length (); i++) {
                // Get the nth object, skipping unexpected elements
                var node = array.get_element (i);
                if (node.get_node_type () != Json.NodeType.OBJECT) {
                    continue;
                }

                // Get the package name and number of ratings from the object - skip if has no name
                var object = node.get_object ();
                var package_name = object.get_string_member ("Name");
                if (package_name != null){
                    warning((string)package_name);
                }
            }*/

        }
        return response;
    }


}
