<#--
  ============================================================================
  Registration page template for the ATDT Keycloak theme
  ============================================================================
  
  This page allows new users to create an account.
-->

<!DOCTYPE html>
<html lang="${(locale.currentLanguageTag)!'es'}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>${msg("registerTitle", "Registro")} - ${realm.displayName!''}</title>
    
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
        <div class="atdt-login-wrapper" style="max-width: 600px;">
          <div class="atdt-login-card">
            
            <#-- Back to login link -->
            <a href="${url.loginUrl}" class="atdt-back-link">
              ← ${msg("backToLogin", "Volver al inicio de sesión")}
            </a>
            
            <div class="atdt-login-header">
              <img class="atdt-logo" src="${url.resourcesPath}/img/logo.svg" alt="Llave MX"/>
              <h1 class="atdt-title">${msg("registerTitle", "Crear cuenta")}</h1>
              <p class="atdt-subtitle">${msg("registerWelcome", "Completa los siguientes datos para registrarte")}</p>
            </div>

            <#if message?has_content && message.summary?has_content>
              <div class="atdt-alert atdt-alert-${message.type}" role="alert">
                <span>${kcSanitize(message.summary)?no_esc}</span>
              </div>
            </#if>

            <form id="kc-register-form" 
                  class="atdt-form" 
                  action="${url.registrationAction}" 
                  method="post">
              
              <#-- First Name -->
              <div class="atdt-form-group">
                <label for="firstName" class="atdt-label">
                  ${msg("firstName", "Nombre(s)")}
                  <span class="atdt-required-indicator">*</span>
                </label>
                <input id="firstName" 
                       name="firstName" 
                       type="text" 
                       class="atdt-input <#if messagesPerField.existsError('firstName')>atdt-input-error</#if>" 
                       value="${(register.formData.firstName!'')}" 
                       autocomplete="given-name"
                       aria-required="true"
                       required />
                <#if messagesPerField.existsError('firstName')>
                  <span class="atdt-error-text" role="alert">
                    ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                  </span>
                </#if>
              </div>

              <#-- Last Name -->
              <div class="atdt-form-group">
                <label for="lastName" class="atdt-label">
                  ${msg("lastName", "Apellido(s)")}
                  <span class="atdt-required-indicator">*</span>
                </label>
                <input id="lastName" 
                       name="lastName" 
                       type="text" 
                       class="atdt-input <#if messagesPerField.existsError('lastName')>atdt-input-error</#if>" 
                       value="${(register.formData.lastName!'')}" 
                       autocomplete="family-name"
                       aria-required="true"
                       required />
                <#if messagesPerField.existsError('lastName')>
                  <span class="atdt-error-text" role="alert">
                    ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                  </span>
                </#if>
              </div>

              <#-- Email -->
              <div class="atdt-form-group">
                <label for="email" class="atdt-label">
                  ${msg("email", "Correo electrónico")}
                  <span class="atdt-required-indicator">*</span>
                </label>
                <input id="email" 
                       name="email" 
                       type="email" 
                       class="atdt-input <#if messagesPerField.existsError('email')>atdt-input-error</#if>" 
                       value="${(register.formData.email!'')}" 
                       autocomplete="email"
                       aria-required="true"
                       required />
                <#if messagesPerField.existsError('email')>
                  <span class="atdt-error-text" role="alert">
                    ${kcSanitize(messagesPerField.get('email'))?no_esc}
                  </span>
                </#if>
              </div>

              <#-- Username (if not using email as username) -->
              <#if !realm.registrationEmailAsUsername>
                <div class="atdt-form-group">
                  <label for="username" class="atdt-label">
                    ${msg("username", "Nombre de usuario")}
                    <span class="atdt-required-indicator">*</span>
                  </label>
                  <input id="username" 
                         name="username" 
                         type="text" 
                         class="atdt-input <#if messagesPerField.existsError('username')>atdt-input-error</#if>" 
                         value="${(register.formData.username!'')}" 
                         autocomplete="username"
                         aria-required="true"
                         required />
                  <#if messagesPerField.existsError('username')>
                    <span class="atdt-error-text" role="alert">
                      ${kcSanitize(messagesPerField.get('username'))?no_esc}
                    </span>
                  </#if>
                </div>
              </#if>

              <#-- Password -->
              <#if passwordRequired??>
                <div class="atdt-form-group">
                  <label for="password" class="atdt-label">
                    ${msg("password", "Contraseña")}
                    <span class="atdt-required-indicator">*</span>
                  </label>
                  <input id="password" 
                         name="password" 
                         type="password" 
                         class="atdt-input <#if messagesPerField.existsError('password')>atdt-input-error</#if>" 
                         autocomplete="new-password"
                         aria-required="true"
                         required />
                  <#if messagesPerField.existsError('password')>
                    <span class="atdt-error-text" role="alert">
                      ${kcSanitize(messagesPerField.get('password'))?no_esc}
                    </span>
                  <#else>
                    <span class="atdt-help-text">
                      ${msg("passwordRequirements", "La contraseña debe tener al menos 8 caracteres")}
                    </span>
                  </#if>
                </div>

                <#-- Password Confirmation -->
                <div class="atdt-form-group">
                  <label for="password-confirm" class="atdt-label">
                    ${msg("passwordConfirm", "Confirmar contraseña")}
                    <span class="atdt-required-indicator">*</span>
                  </label>
                  <input id="password-confirm" 
                         name="password-confirm" 
                         type="password" 
                         class="atdt-input <#if messagesPerField.existsError('password-confirm')>atdt-input-error</#if>" 
                         autocomplete="new-password"
                         aria-required="true"
                         required />
                  <#if messagesPerField.existsError('password-confirm')>
                    <span class="atdt-error-text" role="alert">
                      ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                    </span>
                  </#if>
                </div>
              </#if>

              <#-- reCAPTCHA -->
              <#if recaptchaRequired??>
                <div class="atdt-form-group">
                  <div class="g-recaptcha" data-sitekey="${recaptchaSiteKey}" data-size="compact"></div>
                  <#if messagesPerField.existsError('recaptcha')>
                    <span class="atdt-error-text" role="alert">
                      ${kcSanitize(messagesPerField.get('recaptcha'))?no_esc}
                    </span>
                  </#if>
                </div>
              </#if>

              <#-- Submit button -->
              <button class="atdt-btn atdt-btn-primary atdt-btn-block" 
                      type="submit"
                      name="register"
                      style="margin-top: var(--atdt-spacing-2);">
                ${msg("doRegister", "Registrarse")}
              </button>
            </form>

            <#-- Link back to login -->
            <div class="atdt-links">
              <a href="${url.loginUrl}">
                ${msg("alreadyHaveAccount", "¿Ya tienes una cuenta? Inicia sesión")}
              </a>
            </div>

            <#-- Legal notice -->
            <div class="atdt-legal">
              <small>
                ${msg("registerTermsText", "Al registrarte aceptas nuestros")}
                <a href="${properties.termsLink!'#'}" target="_blank" rel="noopener noreferrer">
                  ${msg("termsTitle", "Términos y Condiciones")}
                </a>
                ${msg("and", "y")}
                <a href="${properties.privacyLink!'#'}" target="_blank" rel="noopener noreferrer">
                  ${msg("privacyTitle", "Aviso de Privacidad")}
                </a>.
              </small>
            </div>

          </div>
        </div>
      </div>
    </main>

    <#-- reCAPTCHA script -->
    <#if recaptchaRequired??>
      <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    </#if>
  </body>
</html>
