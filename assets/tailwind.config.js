const colors = require('tailwindcss/colors')


module.exports = {
  mode: 'jit',
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
  content: [
    '../{lib,forks,deps}/**/*{.leex,.heex,.sface,_live.ex,.js}',
    './js/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        'sans': ['OpenDyslexic', 'Inter', 'Noto Sans', 'Roboto', 'system-ui', 'sans-serif']
      },
      screens: {
        'tablet': '920px',
        'tablet-lg': '1200px'
      },
      maxWidth: {
        '600': '600px'
      },
      colors: {
        gray: colors.gray,
        blueGray: colors.slate,
        amber: colors.amber,
        rose: colors.rose,
        orange: colors.orange,
        teal: colors.teal,
        cyan: colors.cyan
      },
      spacing: {
        '72': '18rem',
        '84': '21rem',
        '90': '22rem',
        '96': '26rem',
      },
      typography: (theme) => ({
        sm: {
          css: {
            fontSize: '15px',
            h1: {
              margin: 0
            },
            h2: {
              margin: 0
            },
            h3: {
              margin: 0
            },
            p: {
              margin: 0,
              lineHeight: '20px' 
            },
            li: {
              lineHeight: '20px'
            }
          }
        },
        lg: {
          css: {
            h1: {
              margin: 0
            },
            h2: {
              margin: 0
            },
            h3: {
              margin: 0
            },
            p: {
              margin: 0,
              lineHeight: '20px' 
            },
            li: {
              lineHeight: '20px'
            }
          }
        }
      }),
    }
  },
  daisyui: {
    themes: [
      {
        bonfire: {
          "primary": "#fde047", 
          "secondary": "#fb923c",
          "accent": "#1FB2A6",
          "neutral": "#191D24",
          "base-100": "rgb(30, 41, 59)",
          "base-300": "rgb(15, 23, 42)",
          "base-content": "rgb(226, 232, 240)",
          "info": "#3ABFF8",
          "success": "#36D399",
          "warning": "#FBBD23",
          "error": "#f15b5b",
        },
      },
      "light", "dark", "cupcake", "bumblebee", "emerald", "corporate", "synthwave", "retro", "cyberpunk", "valentine", "halloween", "garden", "forest", "aqua", "lofi", "pastel", "fantasy", "wireframe", "black", "luxury", "dracula", "cmyk", "autumn", "business", "acid", "lemonade", "night", "coffee", "winter"
    ]
  },
  variants: {
    extend: {
     ringWidth:['hover'],
     divideColor: ['dark'],
     ringColor: ['group-hover', 'hover'],
     fontWeight: ['group-hover'],
     borderWidth: ['hover', 'focus'],
     typography: ['dark']
    }
  },
  plugins: [
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('daisyui')
    // require('tailwindcss-debug-screens')
  ],
}
