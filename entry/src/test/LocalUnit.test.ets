import { describe, it, expect } from '@ohos/hypium';
import { SplitViewModel } from '../main/ets/viewmodel/SplitViewmodel';

export default function localUnitTest() {
  describe('SplitViewModel', () => {

    // --- Phase 1: Core correctness ---

    it('perPerson_zeroPeople_returnsZero', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setPeople(0)
      expect(vm.perPerson).assertEqual(0)
    })

    it('perPerson_negativePeople_returnsZero', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setPeople(-1)
      expect(vm.perPerson).assertEqual(0)
    })

    it('perPerson_normalSplit_correct', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setServiceFee(10)
      vm.setPeople(2)
      expect(vm.totalWithService).assertEqual(110)
      expect(vm.perPerson).assertEqual(55)
    })

    it('perPerson_zeroTotal_returnsZero', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(0)
      vm.setServiceFee(0)
      vm.setPeople(1)
      expect(vm.perPerson).assertEqual(0)
    })

    it('serviceFee_clampedAbove100', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setServiceFee(150)
      expect(vm.serviceFee).assertEqual(100)
      expect(vm.totalWithService).assertEqual(200)
    })

    it('serviceFee_clampedBelowZero', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setServiceFee(-5)
      expect(vm.serviceFee).assertEqual(0)
      expect(vm.totalWithService).assertEqual(100)
    })

    it('total_clampedBelowZero', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(-50)
      expect(vm.total).assertEqual(0)
    })

    it('isValid_onePerson_true', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setPeople(1)
      expect(vm.isValid).assertTrue()
    })

    it('isValid_zeroPeople_false', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setPeople(0)
      expect(vm.isValid).assertFalse()
    })

    // --- Phase 3: Tip ---

    it('tip_combinedWithServiceFee_correct', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(200)
      vm.setServiceFee(10)
      vm.setTip(5)
      vm.setPeople(1)
      expect(vm.totalWithService).assertEqual(230)
    })

    it('tip_combinedSurchargeCappedAt100', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setServiceFee(80)
      vm.setTip(40)
      expect(vm.combinedSurcharge).assertEqual(100)
      expect(vm.totalWithService).assertEqual(200)
    })

    it('tip_clampedBelowZero', 0, () => {
      const vm = new SplitViewModel()
      vm.setTip(-10)
      expect(vm.tip).assertEqual(0)
    })

    it('tip_clampedAbove100', 0, () => {
      const vm = new SplitViewModel()
      vm.setTip(110)
      expect(vm.tip).assertEqual(100)
    })

    // --- Phase 3: Remainder ---

    it('remainder_zeroWhenEvenlyDivisible', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setServiceFee(10)
      vm.setPeople(2)
      expect(vm.remainder).assertEqual(0)
    })

    it('remainder_nonZeroWhenUnevenSplit', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setServiceFee(0)
      vm.setPeople(3)
      expect(vm.remainder).assertLarger(0)
    })

    // --- Phase 3: History ---

    it('history_startsEmpty', 0, () => {
      const vm = new SplitViewModel()
      expect(vm.history.length).assertEqual(0)
    })

    it('history_saveRecord_addsEntry', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setPeople(2)
      vm.saveRecord()
      expect(vm.history.length).assertEqual(1)
      expect(vm.history[0].people).assertEqual(2)
    })

    it('history_maxThreeEntries', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setPeople(2)
      vm.saveRecord()
      vm.saveRecord()
      vm.saveRecord()
      vm.saveRecord()
      expect(vm.history.length).assertEqual(3)
    })

    it('history_newestFirst', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(100)
      vm.setPeople(2)
      vm.saveRecord()
      vm.setTotal(200)
      vm.setPeople(4)
      vm.saveRecord()
      // Most recent (200 total, 4 people) is at index 0
      expect(vm.history[0].total).assertEqual(200)
    })

    it('history_invalidState_doesNotSave', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(50)
      vm.setPeople(0)
      vm.saveRecord()
      expect(vm.history.length).assertEqual(0)
    })

    // --- Reset ---

    it('reset_clearsAllFields', 0, () => {
      const vm = new SplitViewModel()
      vm.setTotal(500)
      vm.setServiceFee(20)
      vm.setTip(10)
      vm.setPeople(5)
      vm.saveRecord()
      vm.reset()
      expect(vm.total).assertEqual(0)
      expect(vm.serviceFee).assertEqual(0)
      expect(vm.tip).assertEqual(0)
      expect(vm.people).assertEqual(1)
      expect(vm.history.length).assertEqual(0)
    })

  })
}
