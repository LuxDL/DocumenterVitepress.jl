import { ref, onMounted } from 'vue'
export const versions = [
  {text: 'stable', link: '/',},
  {text: 'dev', link: '/dev/',},
  {text: 'v0.0.3', link: '/v.0.0.3/'}
]

// shared data across instances so we load only once.
// const versions = ref([])

// const dataHost = 'https://github.com/LuxDL/DocumenterVitepress.jl/blob/gh-pages/'
// const dataUrl = `${dataHost}/versions.js`

// export function useSponsor() {
//     onMounted(async () => {
//       if (versions.value) {
//         return
//       }
  
//       const result = await fetch(dataUrl) // Access-Control-Allow-Origin error
//       // const json = await result.json() // as text instead
  
//       // versions.value = 
//     })
//     return {
//       versions,
//     }
//   }