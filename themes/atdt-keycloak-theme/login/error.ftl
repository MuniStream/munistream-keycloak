<#--
  ============================================================================
  Error page template for the ATDT Keycloak theme
  ============================================================================
  
  This page is displayed whenever Keycloak encounters an unexpected error
  or when the user lands on an unavailable resource. It follows the same
  ATDT design system for consistency.
-->

<!DOCTYPE html>
<html lang="${(locale.currentLanguageTag)!'es'}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>${msg("errorTitle", "Error")} - ${realm.displayName!''}</title>
    
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico"/>
    
    <#-- Design System CSS -->
    <link rel="stylesheet" href="${url.resourcesPath}/css/atdt-design-system.css"/>
    <link rel="stylesheet" href="${url.resourcesPath}/css/login.css"/>
  </head>
  <body class="atdt-login-body">
    <a href="#main-content" class="atdt-skip-link">${msg("skipToContent", "Saltar al contenido principal")}</a>
    
    <#-- Header -->
    <header class="atdt-header" role="banner">
      <div class="atdt-container atdt-header-inner">
        <div class="atdt-header-brand">
          <img class="atdt-header-logo" src="${url.resourcesPath}/img/logo.svg" alt="Llave MX" />
          <span class="atdt-header-title">${realm.displayName!'Llave MX'}</span>
        </div>
      </div>
    </header>
    
    <#-- Main Content -->
    <main id="main-content" class="atdt-main" role="main">
      <div class="atdt-container">
        <div class="atdt-login-wrapper">
          <div class="atdt-login-card atdt-error-page">
            
            <#-- Error Icon / Logo -->
            <div class="atdt-login-header">
              <img class="atdt-logo" src="${url.resourcesPath}/img/logo.svg" alt="Llave MX"/>
            </div>
            
            <#-- Error Message -->
            <h1 class="atdt-h1" style="color: var(--atdt-color-error);">
              ${msg("errorTitle", "Error")}
            </h1>
            
            <#if message?? && message.summary?has_content>
              <div class="atdt-alert atdt-alert-error" role="alert">
                <strong>${kcSanitize(message.summary)?no_esc}</strong>
              </div>
            <#else>
              <div class="atdt-alert atdt-alert-error" role="alert">
                <strong>${msg("errorUnexpected", "Ha ocurrido un error inesperado")}</strong>
              </div>
            </#if>
            
            <#-- Detailed error message if available -->
            <#if message?? && message.detail?has_content>
              <div class="atdt-error-details">
                <p class="atdt-caption atdt-text-muted">
                  <strong>${msg("details", "Detalles")}:</strong>
                </p>
                <code>${kcSanitize(message.detail)?no_esc}</code>
              </div>
            </#if>
            
            <#-- Action buttons -->
            <div style="margin-top: var(--atdt-spacing-4); display: flex; flex-direction: column; gap: var(--atdt-spacing-2);">
              <#-- Link back to client application if available -->
              <#if client?? && client.baseUrl?has_content>
                <a class="atdt-btn atdt-btn-primary atdt-btn-block" href="${client.baseUrl}">
                  ${msg("backToApplication", "Volver a la aplicación")}
                </a>
              </#if>
              
              <#-- Link to login page -->
              <#if url?? && url.loginUrl?has_content>
                <a class="atdt-btn atdt-btn-outlined atdt-btn-block" href="${url.loginUrl}">
                  ${msg("backToLogin", "Volver al inicio de sesión")}
                </a>
              </#if>
              
              <#-- Generic home link if nothing else is available -->
              <#if (!client?? || !client.baseUrl?has_content) && (!url?? || !url.loginUrl?has_content)>
                <a class="atdt-btn atdt-btn-primary atdt-btn-block" href="/">
                  ${msg("backToHome", "Volver al inicio")}
                </a>
              </#if>
            </div>
            
            <#-- Help text -->
            <div class="atdt-legal" style="margin-top: var(--atdt-spacing-4);">
              <small>
                ${msg("errorHelpText", "Si el problema persiste, por favor contacte al administrador del sistema o intente nuevamente más tarde.")}
              </small>
            </div>
            
          </div><#-- /.atdt-login-card -->
        </div><#-- /.atdt-login-wrapper -->
      </div><#-- /.atdt-container -->
    </main>
  </body>
</html>
