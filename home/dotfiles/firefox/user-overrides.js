/* override recipe: enable session restore ***/
user_pref("browser.startup.page", 3); // 0102
  // user_pref("browser.privatebrowsing.autostart", false); // 0110 required if you had it set as true
  // user_pref("browser.sessionstore.privacy_level", 0); // 1003 optional to restore cookies/formdata
user_pref("privacy.clearOnShutdown.history", false); // 2811
  // user_pref("privacy.cpd.history", false); // 2820 optional to match when you use Ctrl-Shift-Del

/*** [SECTION 6750]: DoH ***/
/* 6751: DoH mode ***/
//user_pref("network.trr.mode", 2); // enable TRR (with System fallback)
user_pref("network.trr.mode", 3); // enable TRR (without System fallback)
   // user_pref("network.trr.mode", 5); // Disable TRR
/* 6752: DoH resolver
 * The second pref is optional for DoH mode 2 and required for mode 3 ***/
user_pref("network.trr.uri", "https://doh.opendns.com/dns-query");
//user_pref("network.trr.bootstrapAddress", "x.x.x.x");
/* 6753: DoH resolver list
 DEFAULT(72): [{ "name": "Cloudflare", "url": "https://mozilla.cloudflare-dns.com/dns-query" }]
 DEFAULT(73): "[{ \"name\": \"Cloudflare\", \"url\": \"https://mozilla.cloudflare-dns.com/dns-query\" },{ \"name\": \"NextDNS\", \"url\": \"https://trr.dns.nextdns.io/\" }]"
***/
   // user_pref("network.trr.resolvers", "[{ \"name\": \"<NAME1>\", \"url\": \"https://<URL1>\" }, { \"name\": \"<NAME2>\", \"url\": \"https://<URL2>\" }]");
/* 6754: ***/
user_pref("network.dns.skipTRR-when-parental-control-enabled", false);
/* 6755: enable ESNI
 * ESNI has nothing to do with DoH, but the implementation in Firefox requires it ***/
user_pref("network.security.esni.enabled", true);

user_pref("browser.compactmode.show", true);



/* user.js
 * https://github.com/rafaelmardojai/firefox-gnome-theme/
 */

// Enable customChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Set UI density to normal
user_pref("browser.uidensity", 0);

// Enable SVG context-propertes
user_pref("svg.context-properties.content.enabled", true);

// Disable private window dark theme
user_pref("browser.theme.dark-private-windows", false);

// Enable rounded bottom window corners
user_pref("widget.gtk.rounded-bottom-corners.enabled", true);
