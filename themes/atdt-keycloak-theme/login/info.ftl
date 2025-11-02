<#--
  ============================================================================
  Info page template for the ATDT Keycloak theme
  ============================================================================
  
  This page displays informational messages to users (e.g., "Please verify
  your email", "Account has been created", etc.)
-->

<!DOCTYPE html>
<html lang="${(locale.currentLanguageTag)!'es'}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    
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
            
            <div class="atdt-login-header">
              <img class="atdt-logo" src="${url.resourcesPath}/img/logo.svg" alt="Llave MX"/>
              <h1 class="atdt-title">${realm.displayName!'Llave MX'}</h1>
            </div>

            <#if messageHeader??>
              <h2 class="atdt-h3 atdt-text-center atdt-mb-3">${messageHeader}</h2>
            </#if>

            <#if message?? && message.summary?has_content>
              <div class="atdt-alert atdt-alert-${message.type!'info'}" role="alert">
                ${kcSanitize(message.summary)?no_esc}
              </div>
            </#if>

            <#if requiredActions??>
              <div class="atdt-info-box">
                <p><strong>${msg("requiredActions", "Acciones requeridas")}:</strong></p>
                <ul style="margin: var(--atdt-spacing-1) 0 0 var(--atdt-spacing-3); padding: 0;">
                  <#list requiredActions as action>
                    <li>${msg("requiredAction.${action}")}</li>
                  </#list>
                </ul>
              </div>
            </#if>

            <#if skipLink??>
            <#elseif pageRedirectUri?has_content>
              <div style="margin-top: var(--atdt-spacing-4);">
                <a class="atdt-btn atdt-btn-primary atdt-btn-block" href="${pageRedirectUri}">
                  ${msg("backToApplication", "Volver a la aplicación")}
                </a>
              </div>
            <#elseif actionUri?has_content>
              <div style="margin-top: var(--atdt-spacing-4);">
                <a class="atdt-btn atdt-btn-primary atdt-btn-block" href="${actionUri}">
                  ${msg("proceedWithAction", "Continuar")}
                </a>
              </div>
            <#elseif client?? && client.baseUrl?has_content>
              <div style="margin-top: var(--atdt-spacing-4);">
                <a class="atdt-btn atdt-btn-primary atdt-btn-block" href="${client.baseUrl}">
                  ${msg("backToApplication", "Volver a la aplicación")}
                </a>
              </div>
            </#if>

          </div>
        </div>
      </div>
    </main>
  </body>
</html>
