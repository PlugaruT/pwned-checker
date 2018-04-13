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

namespace PwnedChecker.Services {
    public class PwnedAPI : GLib.Object {
        public signal bool start_loading ();
        public signal bool end_loading ();
        public Soup.Session session;

        private string base_url;

        construct {
            session = new Soup.Session ();
            session.user_agent = "com.github.plugarut.pwned-checker";
            base_url = "https://api.pwnedpasswords.com/";
        }


        public async int check_password (string password) {
            var pwned_count = -1;
            var url = "%spwnedpassword/%s".printf (base_url, password);
            var message = new Soup.Message ("GET", url);
            start_loading ();
            session.queue_message (message, (session, res) => {
                                       if (res.status_code == 200) {
                                           pwned_count = int.parse ((string)res.response_body.flatten ().data);
                                       }
                                      this.check_password.callback ();
                                   });
            end_loading ();
            yield;
            return pwned_count;
        }

        public async string[] check_account (string email) {
            string[] response = { };

            var url = "https://haveibeenpwned.com/api/v2/breachedaccount/%s?truncateResponse=true".printf (email);
            var message = new Soup.Message ("GET", url);

            start_loading ();
            session.queue_message (message, (session, res) => {
                                       if (res.status_code == 200) {
                                           var parser = new Json.Parser ();
                                           try {
                                               parser.load_from_data ((string)res.response_body.flatten ().data, -1);
                                           } catch (Error e) {
                                               warning ("Failed to connect to service: %s", e.message);
                                           }

                                           var root = parser.get_root ();
                                           var array = root.get_array ();

                                           for (var i = 0; i < array.get_length (); i++) {
                                               // Get the nth object, skipping unexpected elements
                                               var node = array.get_element (i);
                                               if (node.get_node_type () != Json.NodeType.OBJECT) {
                                                   continue;
                                               }

                                               var object = node.get_object ();
                                               var name = object.get_string_member ("Name");
                                               if (name != null) {
                                                   response += name;
                                               }
                                           }
                                       }
                                       this.check_account.callback ();
                                   });
            end_loading ();
            yield;
            return response;
        }
    }
}
