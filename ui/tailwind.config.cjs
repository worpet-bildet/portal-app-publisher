module.exports = {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx,svelte}'],
  theme: {
    fontFamily: {
      logo: ['krona'],
      saucebold: ['sauce-bold'],
    },
    extend: {
      colors: {
        gray: '#242424',
        blackoverlay: '#00000080',
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
