<#--
  ============================================================================
  Login page template for the ATDT Keycloak theme
  ============================================================================
  
  Based on: UI KIT (ATDT) - Febrero 2025
  Version: 1.0.0
  
  This template implements the ATDT design system following:
  - 8pt Grid System
  - Noto Sans typography
  - Guinda color palette
  - Government accessibility standards (WCAG 2.1 AA)
  - Llave MX branding guidelines
  
  The template avoids inheriting built-in Keycloak layouts for full control
  over markup structure. All translations use built-in message bundles.
-->

<!DOCTYPE html>
<html lang="${(locale.currentLanguageTag)!'es'}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    
    <#if properties.meta?has_content>
      <#list properties.meta?split(' ') as meta>
        <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
      </#list>
    </#if>
    
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico"/>
    
    <#-- Design System CSS -->
    <link rel="stylesheet" href="${url.resourcesPath}/css/atdt-design-system.css"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/login.css"/>
    
    <#if properties.styles?has_content>
      <#list properties.styles?split(' ') as style>
        <link rel="stylesheet" href="${url.resourcesPath}/${style}"/>
      </#list>
    </#if>
  </head>
  <body class="atdt-login-body">
    <#-- Skip to main content for accessibility -->
    <a href="#main-content" class="atdt-skip-link">${msg("skipToContent", "Saltar al contenido principal")}</a>
    
    <#-- 
      ========================================================================
      HEADER
      ========================================================================
      Consistent header across all pages following UI KIT specifications
    -->
    <header class="atdt-header" role="banner">
      <div class="atdt-container atdt-header-inner">
        <div class="atdt-header-brand">
          <img class="atdt-header-logo" src="${url.resourcesPath}/img/logo.svg" alt="Llave MX" />
          <span class="atdt-header-title">${realm.displayName!'Llave MX'}</span>
        </div>
      </div>
    </header>
    
    <#-- 
      ========================================================================
      MAIN CONTENT
      ========================================================================
    -->
    <main id="main-content" class="atdt-main" role="main">
      <div class="atdt-container">
        <div class="atdt-login-wrapper">
          <div class="atdt-login-card">
            
            <#-- 
              ==================================================================
              LOGIN HEADER (Logo & Welcome)
              ==================================================================
            -->
            <div class="atdt-login-header">
              <img class="atdt-logo" src="${url.resourcesPath}/img/logo.svg" alt="Llave MX"/>
              <h1 class="atdt-title">${realm.displayName!'Llave MX'}</h1>
              <p class="atdt-subtitle">${msg("loginWelcome", "Te damos la bienvenida")}</p>
            </div>

            <#-- 
              ==================================================================
              ALERT MESSAGES (Error, Info, Warning, Success)
              ==================================================================
            -->
            <#if message?has_content && message.summary?has_content>
              <div class="atdt-alert atdt-alert-${message.type}" role="alert">
                <#if message.type == 'error'>
                  <span class="atdt-sr-only">${msg("error", "Error")}:</span>
                </#if>
                <span>${kcSanitize(message.summary)?no_esc}</span>
              </div>
            </#if>

            <#-- 
              ==================================================================
              SOCIAL / IDENTITY PROVIDER LOGINS
              ==================================================================
              Displays buttons for external authentication providers like
              OpenID Connect, SAML, etc.
            -->
            <#if social?? && social.providers?has_content>
              <div class="atdt-idp" role="region" aria-label="${msg("socialLogin", "Inicio de sesión social")}">
                <p class="atdt-idp-title">${msg("doSignInWith", "Inicia sesión con:")}</p>
                <div class="atdt-idp-buttons">
                  <#list social.providers as provider>
                    <a class="atdt-btn atdt-btn-outlined" 
                       href="${provider.loginUrl}"
                       id="social-${provider.alias}">
                      ${provider.displayName}
                    </a>
                  </#list>
                </div>
              </div>
            </#if>

            <#-- 
              ==================================================================
              LOGIN FORM
              ==================================================================
            -->
            <form id="kc-form-login" 
                  class="atdt-form" 
                  action="${url.loginAction}" 
                  method="post"
                  novalidate>
              
              <#-- Username / Email field -->
              <div class="atdt-form-group">
                <label for="username" class="atdt-label">
                  <#if !realm.loginWithEmailAllowed>
                    ${msg("username", "Nombre de usuario")}
                  <#elseif !realm.registrationEmailAsUsername>
                    ${msg("usernameOrEmail", "Usuario o correo electrónico")}
                  <#else>
                    ${msg("email", "Correo electrónico")}
                  </#if>
                </label>
                <input id="username" 
                       name="username" 
                       type="text" 
                       class="atdt-input" 
                       value="${(login.username!'')}" 
                       autofocus 
                       autocomplete="username"
                       aria-required="true"
                       required />
              </div>

              <#-- Password field -->
              <div class="atdt-form-group">
                <label for="password" class="atdt-label">
                  ${msg("password", "Contraseña")}
                </label>
                <input id="password" 
                       name="password" 
                       type="password" 
                       class="atdt-input" 
                       autocomplete="current-password"
                       aria-required="true"
                       required />
              </div>

              <#-- Remember Me checkbox -->
              <#if realm.rememberMe && !usernameEditDisabled??>
                <div class="atdt-remember-me">
                  <input id="rememberMe" 
                         name="rememberMe" 
                         type="checkbox"
                         <#if login.rememberMe??>checked</#if>
                         aria-describedby="rememberMeHelp">
                  <label for="rememberMe">${msg("rememberMe", "Recordarme")}</label>
                </div>
              </#if>

              <#-- Submit button -->
              <button id="kc-login" 
                      class="atdt-btn atdt-btn-primary atdt-btn-block" 
                      type="submit"
                      name="login">
                ${msg("doLogIn", "Iniciar sesión")}
              </button>
            </form>

            <#-- 
              ==================================================================
              ADDITIONAL LINKS (Forgot password, Register)
              ==================================================================
            -->
            <#if realm.resetPasswordAllowed || realm.password && realm.registrationAllowed>
              <div class="atdt-links">
                <#if realm.resetPasswordAllowed>
                  <a href="${url.loginResetCredentialsUrl}">
                    ${msg("doForgotPassword", "¿Olvidaste tu contraseña?")}
                  </a>
                </#if>
                <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
                  <a href="${url.registrationUrl}">
                    ${msg("doRegister", "Crear cuenta")}
                  </a>
                </#if>
              </div>
            </#if>

            <#-- 
              ==================================================================
              LEGAL NOTICE (Terms & Privacy)
              ==================================================================
            -->
            <div class="atdt-legal">
              <small>
                ${msg("loginTermsText", "Al iniciar sesión declaro que he leído los")}
                <a href="${properties.termsLink!'#'}" target="_blank" rel="noopener noreferrer">
                  ${msg("termsTitle", "Términos y Condiciones")}
                </a>
                ${msg("and", "y nuestro")}
                <a href="${properties.privacyLink!'#'}" target="_blank" rel="noopener noreferrer">
                  ${msg("privacyTitle", "Aviso de Privacidad")}
                </a>.
              </small>
            </div>

          </div><#-- /.atdt-login-card -->
        </div><#-- /.atdt-login-wrapper -->
      </div><#-- /.atdt-container -->
    </main>

    <#-- 
      ========================================================================
      SCRIPTS (if needed)
      ========================================================================
    -->
    <#if properties.scripts?has_content>
      <#list properties.scripts?split(' ') as script>
        <script src="${url.resourcesPath}/${script}" defer></script>
      </#list>
    </#if>
  </body>
</html>
