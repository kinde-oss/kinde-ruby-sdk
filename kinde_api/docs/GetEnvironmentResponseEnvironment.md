# KindeApi::GetEnvironmentResponseEnvironment

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | The unique identifier for the environment. | [optional] |
| **name** | **String** | The environment&#39;s name. | [optional] |
| **hotjar_site_id** | **String** | Your HotJar site ID. | [optional] |
| **google_analytics_tag** | **String** | Your Google Analytics tag. | [optional] |
| **is_default** | **Boolean** | Whether the environment is the default. Typically this is your production environment. | [optional] |
| **is_live** | **Boolean** | Whether the environment is live. | [optional] |
| **kinde_domain** | **String** | Your domain on Kinde | [optional] |
| **custom_domain** | **String** | Your custom domain for the environment | [optional] |
| **logo** | **String** | The organization&#39;s logo URL. | [optional] |
| **logo_dark** | **String** | The organization&#39;s logo URL to be used for dark themes. | [optional] |
| **favicon_svg** | **String** | The organization&#39;s SVG favicon URL. Optimal format for most browsers | [optional] |
| **favicon_fallback** | **String** | The favicon URL to be used as a fallback in browsers that don’t support SVG, add a PNG | [optional] |
| **link_color** | [**GetEnvironmentResponseEnvironmentLinkColor**](GetEnvironmentResponseEnvironmentLinkColor.md) |  | [optional] |
| **background_color** | [**GetEnvironmentResponseEnvironmentBackgroundColor**](GetEnvironmentResponseEnvironmentBackgroundColor.md) |  | [optional] |
| **button_color** | [**GetEnvironmentResponseEnvironmentLinkColor**](GetEnvironmentResponseEnvironmentLinkColor.md) |  | [optional] |
| **button_text_color** | [**GetEnvironmentResponseEnvironmentBackgroundColor**](GetEnvironmentResponseEnvironmentBackgroundColor.md) |  | [optional] |
| **link_color_dark** | [**GetEnvironmentResponseEnvironmentLinkColor**](GetEnvironmentResponseEnvironmentLinkColor.md) |  | [optional] |
| **background_color_dark** | [**GetEnvironmentResponseEnvironmentLinkColor**](GetEnvironmentResponseEnvironmentLinkColor.md) |  | [optional] |
| **button_text_color_dark** | [**GetEnvironmentResponseEnvironmentLinkColor**](GetEnvironmentResponseEnvironmentLinkColor.md) |  | [optional] |
| **button_color_dark** | [**GetEnvironmentResponseEnvironmentLinkColor**](GetEnvironmentResponseEnvironmentLinkColor.md) |  | [optional] |
| **button_border_radius** | **Integer** | The border radius for buttons. Value is px, Kinde transforms to rem for rendering | [optional] |
| **card_border_radius** | **Integer** | The border radius for cards. Value is px, Kinde transforms to rem for rendering | [optional] |
| **input_border_radius** | **Integer** | The border radius for inputs. Value is px, Kinde transforms to rem for rendering | [optional] |
| **theme_code** | **String** | Whether the environment is forced into light mode, dark mode or user preference | [optional] |
| **color_scheme** | **String** | The color scheme for the environment used for meta tags based on the theme code | [optional] |
| **created_on** | **String** | Date of environment creation in ISO 8601 format. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetEnvironmentResponseEnvironment.new(
  code: production,
  name: Production,
  hotjar_site_id: 404009,
  google_analytics_tag: G-1234567,
  is_default: true,
  is_live: true,
  kinde_domain: example.kinde.com,
  custom_domain: app.example.com,
  logo: https://yoursubdomain.kinde.com/logo?org_code&#x3D;org_1ccfb819462&amp;cache&#x3D;311308b8ad3544bf8e572979f0e5748d,
  logo_dark: https://yoursubdomain.kinde.com/logo_dark?org_code&#x3D;org_1ccfb819462&amp;cache&#x3D;311308b8ad3544bf8e572979f0e5748d,
  favicon_svg: https://yoursubdomain.kinde.com/favicon_svg?org_code&#x3D;org_1ccfb819462&amp;cache&#x3D;311308b8ad3544bf8e572979f0e5748d,
  favicon_fallback: https://yoursubdomain.kinde.com/favicon_fallback?org_code&#x3D;org_1ccfb819462&amp;cache&#x3D;311308b8ad3544bf8e572979f0e5748d,
  link_color: null,
  background_color: null,
  button_color: null,
  button_text_color: null,
  link_color_dark: null,
  background_color_dark: null,
  button_text_color_dark: null,
  button_color_dark: null,
  button_border_radius: 8,
  card_border_radius: 16,
  input_border_radius: 4,
  theme_code: null,
  color_scheme: null,
  created_on: 2021-01-01T00:00:00Z
)
```

