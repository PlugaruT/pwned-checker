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
        public Soup.Session session;

        private string password_url;
        private string account_url;

        construct {
            session = new Soup.Session ();
            session.user_agent = "com.github.plugarut.pwned-checker";
            password_url= "https://api.pwnedpasswords.com/range/";
            account_url = "https://haveibeenpwned.com/api/v2/breachedaccount/";
        }


        public async int check_password (string password) {
            int pwned_count = -1;
            string hash = Checksum.compute_for_string (ChecksumType.SHA1, password).up ();
            string url = "%s%s".printf (password_url, hash.slice (0, 5));
            Soup.Message message = new Soup.Message ("GET", url);

            session.queue_message (message, (session, res) => {
                                       if (res.status_code == 200) {
                                           string response = (string)res.response_body.flatten ().data;
                                           var hash_list = response.split ("\n");
                                           for (var i = 0; i < hash_list.length; i++) {
                                               var hash_and_count = hash_list[i].split (":");
                                               var full_hash = hash.slice (0, 5) + hash_and_count[0];
                                               if (full_hash == hash) {
                                                   pwned_count = int.parse (hash_and_count[1]);
                                                   break;
                                               }
                                           };
                                       } else {
                                           pwned_count = -2;
                                       }
                                       this.check_password.callback ();
                                   });
            yield;
            return pwned_count;
        }

        public async string[] check_account (string email) {
            string[] response = { };

            var url = "%s%s?truncateResponse=true".printf (account_url, email);
            var message = new Soup.Message ("GET", url);

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
                                       else {
		                                    response += "Invalid Response";
                                       }
                                       this.check_account.callback ();
                                   });
            yield;
            return response;
        }
    }
}
