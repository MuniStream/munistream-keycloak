<#--
  Login page template for the ATDT Keycloak theme.

  This template intentionally avoids inheriting the built‑in
  Keycloak layouts so that we can have full control over the markup
  structure.  All translations come from the built‑in message
  bundles.  The overall design is based on the ATDT UI Kit and the
  Llave MX “Guía de uso” document.  Colors, typography and spacing
  follow the 8pt grid system described in the provided PDFs.
-->

<!DOCTYPE html>
<html lang="${locale.currentLanguage}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>${realm.displayName!msg("loginTitle")}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/style.css"/>
  </head>
  <body class="atdt-login-body">
    <div class="atdt-login-wrapper">
      <div class="atdt-login-card">
        <div class="atdt-login-header">
          <img class="atdt-logo" src="${url.resourcesPath}/img/logo.svg" alt="Llave MX"/>
          <h1 class="atdt-title">${realm.displayName!'Llave MX'}</h1>
          <p class="atdt-subtitle">Te damos la bienvenida</p>
        </div>

        <#-- Global error or info messages -->
        <#if message?has_content>
          <div class="atdt-alert atdt-alert-${message.type!'info'}">
            <span>${message.summary}</span>
          </div>
        </#if>

        <form id="kc-form-login" class="atdt-form" action="${url.loginAction}" method="post">
          <div class="atdt-form-group">
            <label for="username" class="atdt-label">${msg("usernameOrEmail")?default("Usuario o correo electrónico")}</label>
            <input id="username" name="username" type="text" class="atdt-input" value="${auth.attemptedUsername}" autofocus required />
          </div>

          <div class="atdt-form-group">
            <label for="password" class="atdt-label">${msg("password")?default("Contraseña")}</label>
            <input id="password" name="password" type="password" class="atdt-input" autocomplete="current-password" required />
          </div>

          <#if realm.rememberMe??>
            <div class="atdt-form-group atdt-remember-me">
              <input id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMeChecked??>checked="checked"</#if>>
              <label for="rememberMe">${msg("rememberMe")?default("Recordarme")}</label>
            </div>
          </#if>

          <button id="kc-login" class="atdt-btn atdt-btn-primary" type="submit">${msg("doSignIn")?default("Iniciar sesión")}</button>
        </form>

        <div class="atdt-links">
          <#if realm.resetPasswordAllowed>
            <a href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")?default("¿Olvidaste tu contraseña?")}</a>
          </#if>
          <#if realm.registrationAllowed>
            <a href="${url.registrationUrl}">${msg("doRegister")?default("Crear cuenta")}</a>
          </#if>
        </div>

        <div class="atdt-legal">
          <small>
            Al iniciar sesión declaro que he leído los
            <a href="${properties['termsLink']?default('#')}" target="_blank">Términos y Condiciones</a>
            y nuestro
            <a href="${properties['privacyLink']?default('#')}" target="_blank">Aviso de Privacidad</a>.
          </small>
        </div>
      </div>
    </div>
  </body>
</html>