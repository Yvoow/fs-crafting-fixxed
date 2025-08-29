export default {
    content: [
      "./index.html",
      "./src/**/*.{js,ts,vue,jsx,tsx}",
    ],
    plugins: [],
    theme: {
      extend: {
        fontFamily: {
          jakarta: ['Plus Jakarta Sans', 'sans-serif'],
        },
        colors: {
          primary: 'var(--primary)',
          secondary: 'var(--secondary)',
          background: 'var(--background)',
          blocks: 'var(--blocks)',
          blocks2: 'var(--blocks2)',
          primaryText: 'var(--primaryText)',
          secondaryText: 'var(--secondaryText)',
        },
      },
    }
  }