// localeManager.ts
import { fetchData } from './fetchData'

let locales = {}

export async function initLocales() {
    locales = await fetchData('fetchLocales')
}

export function getLocale(key) {
  if (!locales) {
      setTimeout(async () => {
          await initLocales()
      }, 1000)
  }
  const locale = locales[key]
  if (!locale) return 'Missing translation for ' + key
  return locale
}