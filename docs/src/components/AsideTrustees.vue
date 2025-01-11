
<template>
  <br>
  <h2> Trusted by </h2>
  <a
    class="enjoyer"
    href="https://rafaqz.github.io/DimensionalData.jl/dev/"
    target="_blank"
  >
    <img width="32" height="32" src="https://rafaqz.github.io/DimensionalData.jl/dev/logo.png" />
    <span>
      <p class="extra-info">Named Dimensions</p>
      <p class="heading">DimensionalData.jl</p>
      <p class="extra-info">Select & Index!</p>
    </span>
  </a>

  <a
    class="enjoyer"
    href="https://lux.csail.mit.edu/"
    target="_blank"
  >
    <img width="32" height="32" src="https://raw.githubusercontent.com/LuxDL/Lux.jl/main/assets/lux-logo-dark.svg" />
    <span>
      <p class="extra-info">Deep Learning</p>
      <p class="heading">Lux.jl</p>
      <p class="extra-info">Performance first</p>
    </span>
  </a>

  <a
    class="enjoyer"
    href="https://beautiful.makie.org"
    target="_blank"
  >
    <img width="32" height="32" src="https://beautiful.makie.org/dev/test_alpha_s.png" />
    <span>
      <p class="extra-info">Visualize your data</p>
      <p class="heading">BeautifulMakie</p>
      <p class="extra-info">Make your screen shine!</p>
    </span>
  </a>
</template>

<style>
.enjoyer {
  margin-top: 0.5rem;
  margin-bottom: 0.0rem;
  border-radius: 14px;
  padding-top: 0.2rem;
  padding-bottom: 0.2rem;
  position: relative;
  font-size: 0.9rem;
  font-weight: 700;
  line-height: 1.1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  gap: 1rem;
  background-color: var(--vp-c-bg-alt);
  border: 1.25px solid var(--vp-c-bg-alt);
  transition: border-color 0.5s;
}
.enjoyer:hover {
  border: 1.25px solid var(--vp-c-brand-1);
}
.enjoyer img {
  transition: transform 0.5s;
  transform: scale(1.25);
}
.enjoyer:hover img {
  transform: scale(1.75);
}
.enjoyer .heading {
  background-image: linear-gradient(
    120deg,
    #b047ff 16%,
    var(--vp-c-brand-lighter),
    var(--vp-c-brand-lighter)
  );
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
.enjoyer .extra-info {
  color: var(--vp-c-text-1);
  opacity: 0;
  font-size: 0.7rem;
  padding-left: 0.1rem;
  transition: opacity 0.5s;
}
.enjoyer:hover .extra-info {
  opacity: 0.9;
}
</style>
