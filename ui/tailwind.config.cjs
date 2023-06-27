module.exports = {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx,svelte}'],
  theme: {
    fontFamily: {
      logo: ['krona'],
      saucebold: ['sauce-bold'],
    },
    extend: {
      colors: {
        grey: '#696969',
        blackoverlay: '#00000080',
        offwhite: '#c5c5c5',
      },
      borderColor: {
        DEFAULT: '#69696940',
        error: 'rgb(220 38 38)',
        spacer: '#696969',
      },
    },

    // boxShadow: {
    //   DEFAULT: '0 0 20px 0 #69696920',
    // },
  },
  screens: {},
  variants: {
    extend: {},
  },
  darkMode: 'class',
};
