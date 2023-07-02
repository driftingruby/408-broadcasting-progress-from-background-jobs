import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progress-bar"
export default class extends Controller {
  static values = {
    totalJobs: 0,
    completedJobs: 0
  }
  static targets = ["progress"]
  connect() {
    this.observer = new MutationObserver((mutationsList, _observer) => {
      for (let mutation of mutationsList) {
        if (mutation.type === 'childList') {
          this.increment()
        }
      }
    })

    this.observer.observe(this.element, { childList: true })
  }

  increment() {
    this.completedJobsValue++
    this.updateProgress()
  }

  updateProgress() {
    let progress = (this.completedJobsValue / this.totalJobsValue) * 100
    this.progressTarget.style.width = `${progress}%`
  }
}
