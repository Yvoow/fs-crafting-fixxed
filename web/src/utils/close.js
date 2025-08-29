import { fetchData } from './fetchData'

export const close = () => {
  document.body.style.display = 'none'
  fetchData('close')
}