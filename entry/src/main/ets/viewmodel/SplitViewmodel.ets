export interface SplitRecord {
  total: number
  perPerson: number
  people: number
  timestamp: number
}

@Observed
export class SplitViewModel {
  total: number = 0
  serviceFee: number = 0
  people: number = 1
  tip: number = 0
  history: SplitRecord[] = []

  setTotal(v: number): void {
    this.total = v < 0 ? 0 : v
  }

  setServiceFee(v: number): void {
    if (v < 0) { this.serviceFee = 0 }
    else if (v > 100) { this.serviceFee = 100 }
    else { this.serviceFee = v }
  }

  setPeople(v: number): void {
    this.people = v < 0 ? 0 : v
  }

  setTip(v: number): void {
    if (v < 0) { this.tip = 0 }
    else if (v > 100) { this.tip = 100 }
    else { this.tip = v }
  }

  get combinedSurcharge(): number {
    const combined = this.serviceFee + this.tip
    return combined > 100 ? 100 : combined
  }

  get totalWithService(): number {
    return this.total + this.total * this.combinedSurcharge / 100
  }

  get perPerson(): number {
    if (this.people <= 0) {
      return 0
    }
    return this.totalWithService / this.people
  }

  get isValid(): boolean {
    return this.people >= 1 && this.total >= 0
  }

  get remainder(): number {
    if (!this.isValid) {
      return 0
    }
    const raw = this.totalWithService - this.perPerson * this.people
    return Math.round(raw * 100) / 100
  }

  saveRecord(): void {
    if (!this.isValid) {
      return
    }
    const record: SplitRecord = {
      total: this.total,
      perPerson: this.perPerson,
      people: this.people,
      timestamp: Date.now()
    }
    const newHistory = [record, ...this.history]
    if (newHistory.length > 3) {
      newHistory.pop()
    }
    this.history = newHistory
  }

  reset(): void {
    this.total = 0
    this.serviceFee = 0
    this.people = 1
    this.tip = 0
    this.history = []
  }
}
