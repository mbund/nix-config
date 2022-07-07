{ lib, pkgs, self, ... }:
let
  arkenfox = builtins.readFile "${self.inputs.arkenfox-userjs}/user.js";
  overrides = {
    # arkenfox overrides
    ## automatic search
    "keyword.enabled" = true;
    "browser.search.suggest.enabled" = true;
    "browser.urlbar.suggest.searches" = true;

    ## startup page
    "browser.startup.homepage" = "https://searxng.moritzboeh.me/";
    "browser.startup.page" = 1;

    ## drm
    "media.eme.enabled" = true;

    ## sanitisation
    "privacy.clearOnShutdown.history" = false;

    ## disable letterboxing
    "privacy.resistFingerprinting.letterboxing" = false;

    # other
    ## don't show warning when accessing about:config
    "browser.aboutConfig.showWarning" = false;

    ## hide bookmarks
    "browser.toolbars.bookmarks.visibility" = "never";

    ## smooth scrolling
    "general.smoothScroll.lines.durationMaxMS" = 125;
    "general.smoothScroll.lines.durationMinMS" = 125;
    "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
    "general.smoothScroll.mouseWheel.durationMinMS" = 100;
    "general.smoothScroll.msdPhysics.enabled" = true;
    "general.smoothScroll.other.durationMaxMS" = 125;
    "general.smoothScroll.other.durationMinMS" = 125;
    "general.smoothScroll.pages.durationMaxMS" = 125;
    "general.smoothScroll.pages.durationMinMS" = 125;
    "mousewheel.min_line_scroll_amount" = 40;
    "mousewheel.system_scroll_override_on_root_content.enabled" = true;
    "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
    "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;
    "toolkit.scrollbox.horizontalScrollDistance" = 6;
    "toolkit.scrollbox.verticalScrollDistance" = 2;
  };

  fullUserJs = ''
    // arkenfox user.js
    ${arkenfox}

    // overrides
    ${lib.concatStrings (lib.mapAttrsToList (name: value: ''
      user_pref("${name}", ${builtins.toJSON value});
    '') overrides)}
  '';
in
{
  programs.firefox = {
    enable = true;
    profiles."default".extraConfig = fullUserJs;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      skip-redirect
      i-dont-care-about-cookies
      bitwarden
    ];
  };

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_DBUS_REMOTE = "1";
  };

  xdg.mimeApps.defaultApplications = {
    "application/x-extension-htm" = "firefox.desktop";
    "application/x-extension-html" = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/x-extension-xht" = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "x-scheme-handler/chrome" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
  };
}
