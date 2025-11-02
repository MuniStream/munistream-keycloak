<#--
  ============================================================================
  Password Reset Request page template for the ATDT Keycloak theme
  ============================================================================
  
  This page allows users to request a password reset link via email.
-->

<!DOCTYPE html>
<html lang="${(locale.currentLanguageTag)!'es'}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>${msg("emailForgotTitle", "Recuperar contraseña")} - ${realm.displayName!''}</title>
    
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico"/>
    
    <link rel="stylesheet" href="${url.resourcesPath}/css/atdt-design-system.css"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/login.css"/>
  </head>
  <body class="atdt-login-body">
    <a href="#main-content" class="atdt-skip-link">${msg("skipToContent", "Saltar al contenido principal")}</a>
    
    <header class="atdt-header" role="banner">
      <div class="atdt-container atdt-header-inner">
        <div class="atdt-header-brand">
          <img class="atdt-header-logo" src="${url.resourcesPath}/img/logo.svg" alt="Llave MX" />
          <span class="atdt-header-title">${realm.displayName!'Llave MX'}</span>
        </div>
      </div>
    </header>
    
    <main id="main-content" class="atdt-main" role="main">
      <div class="atdt-container">
        <div class="atdt-login-wrapper">
          <div class="atdt-login-card">
            
            <#-- Back to login link -->
            <a href="${url.loginUrl}" class="atdt-back-link">
              ← ${msg("backToLogin", "Volver al inicio de sesión")}
            </a>
            
            <div class="atdt-login-header">
              <img class="atdt-logo" src="${url.resourcesPath}/img/logo.svg" alt="Llave MX"/>
              <h1 class="atdt-title">${msg("emailForgotTitle", "¿Olvidaste tu contraseña?")}</h1>
              <p class="atdt-subtitle">${msg("emailInstruction", "Ingresa tu usuario o correo electrónico y te enviaremos instrucciones para restablecer tu contraseña.")}</p>
            </div>

            <#if message?has_content && message.summary?has_content>
              <div class="atdt-alert atdt-alert-${message.type}" role="alert">
                <span>${kcSanitize(message.summary)?no_esc}</span>
              </div>
            </#if>

            <form id="kc-reset-password-form" 
                  class="atdt-form" 
                  action="${url.loginAction}" 
                  method="post">
              
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
                       value="${(auth.attemptedUsername!'')}" 
                       autofocus 
                       autocomplete="username"
                       aria-required="true"
                       required />
              </div>

              <button class="atdt-btn atdt-btn-primary atdt-btn-block" 
                      type="submit"
                      name="login">
                ${msg("doSubmit", "Enviar")}
              </button>
            </form>

            <div class="atdt-links">
              <a href="${url.loginUrl}">
                ${msg("backToLogin", "Volver al inicio de sesión")}
              </a>
              <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
                <a href="${url.registrationUrl}">
                  ${msg("doRegister", "Crear cuenta")}
                </a>
              </#if>
            </div>

          </div>
        </div>
      </div>
    </main>
  </body>
</html>
