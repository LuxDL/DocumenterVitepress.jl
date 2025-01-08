<template>
  <span class="badge-container">
    <span class="badge-label">Author</span>
    <span class="author-badge" :style="{ backgroundColor: getColor(author) }">
      <img v-if="avatar" :src="avatar" :alt="author" class="author-avatar">
      {{ author }}
    </span>
  </span>
</template>

<script setup>
const props = defineProps({
  author: {
    type: String,
    required: true
  },
  avatar: {
    type: String,
    default: 'https://github.com/favicon.ico'
  }
})

// Simple function to generate consistent colors for authors
const getColor = (name) => {
  const colors = [
    '#3eaf7c', // green
    '#476582', // blue
    '#c53e3e', // red
    '#986801', // orange
    '#8957e5'  // purple
  ]
  const hash = name.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0)
  return colors[hash % colors.length]
}
</script>

<style scoped>
.badge-container {
  display: inline-flex;
  height: 20px;
  font-size: 12px;
  font-weight: 500;
  border-radius: 5px;
  margin-right: 0.5rem;
  margin-bottom: 0.5rem;
  overflow: hidden;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
}

.badge-label {
  padding: 0 8px;
  background-color: #555;
  color: white;
  display: flex;
  align-items: center;
}

.author-badge {
  display: inline-flex;
  align-items: center;
  padding: 0 8px;
  color: white;
}

.author-avatar {
  width: 15px;
  height: 15px;
  border-radius: 50%;
  margin-right: 0.25rem;
  margin-left: -0.25rem;
  filter: brightness(0) invert(1);
}
</style>