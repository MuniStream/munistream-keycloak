<#--
  Error page template for the ATDT Keycloak theme.
  This page is displayed whenever Keycloak encounters an unexpected
  error or when the user lands on an unavailable resource.
  It reuses the same stylesheet and design language as the login
  template so that the experience remains consistent.
-->

<!DOCTYPE html>
<html lang="${(locale.currentLanguage)!'es'}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>${message.summary!'Error'}</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/style.css"/>
  </head>
  <body class="atdt-login-body">
    <div class="atdt-login-wrapper">
      <div class="atdt-login-card">
        <h1 class="atdt-title">${message.summary!'Se produjo un error'}</h1>
        <p>${message.detail?default('Ha ocurrido un error inesperado.')}</p>
        <#-- Offer a way back to the client application when available -->
        <#if client?? && client.baseUrl??>
          <p style="text-align:center; margin-top:16px;">
            <a class="atdt-btn atdt-btn-primary" href="${client.baseUrl}">Volver a la aplicación</a>
          </p>
        </#if>
      </div>
    </div>
  </body>
</html>