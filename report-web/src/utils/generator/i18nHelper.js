function deepClone(obj) {
  return JSON.parse(JSON.stringify(obj))
}

function localizeOptions(options, t) {
  if (!Array.isArray(options)) return options
  return options.map((opt, index) => ({
    ...opt,
    label: t(`tool.generator.option${index + 1}`, opt.label)
  }))
}

function localizeComponent(component, t) {
  const clone = deepClone(component)
  if (clone.tagIcon) {
    clone.label = t(`tool.generator.${clone.tagIcon}`, clone.label)
  }
  if (clone.placeholder) {
    clone.placeholder = t('tool.generator.placeholder')
  }
  if (clone.options) {
    clone.options = localizeOptions(clone.options, t)
    clone.options.forEach((opt) => {
      if (opt.children) {
        opt.children = localizeOptions(opt.children, t)
      }
    })
  }
  return clone
}

export function localizeComponentList(components, t) {
  return components.map((item) => localizeComponent(item, t))
}
