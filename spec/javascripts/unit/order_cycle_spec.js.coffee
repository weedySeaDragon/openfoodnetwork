describe 'OrderCycle controllers', ->

  describe 'AdminCreateOrderCycleCtrl', ->
    ctrl = null
    scope = null
    event = null
    OrderCycle = null
    Enterprise = null
    EnterpriseFee = null

    beforeEach ->
      scope = {}
      event =
        preventDefault: jasmine.createSpy('preventDefault')
      OrderCycle =
        order_cycle: 'my order cycle'
        exchangeSelectedVariants: jasmine.createSpy('exchangeSelectedVariants').andReturn('variants selected')
        productSuppliedToOrderCycle: jasmine.createSpy('productSuppliedToOrderCycle').andReturn('product supplied')
        variantSuppliedToOrderCycle: jasmine.createSpy('variantSuppliedToOrderCycle').andReturn('variant supplied')
        exchangeDirection: jasmine.createSpy('exchangeDirection').andReturn('exchange direction')
        toggleProducts: jasmine.createSpy('toggleProducts')
        setExchangeVariants: jasmine.createSpy('setExchangeVariants')
        addSupplier: jasmine.createSpy('addSupplier')
        addDistributor: jasmine.createSpy('addDistributor')
        removeExchange: jasmine.createSpy('removeExchange')
        addCoordinatorFee: jasmine.createSpy('addCoordinatorFee')
        removeCoordinatorFee: jasmine.createSpy('removeCoordinatorFee')
        addExchangeFee: jasmine.createSpy('addExchangeFee')
        removeExchangeFee: jasmine.createSpy('removeExchangeFee')
        removeDistributionOfVariant: jasmine.createSpy('removeDistributionOfVariant')
        create: jasmine.createSpy('create')
      Enterprise =
        index: jasmine.createSpy('index').andReturn('enterprises list')
        supplied_products: 'supplied products'
        suppliedVariants: jasmine.createSpy('suppliedVariants').andReturn('supplied variants')
        totalVariants: jasmine.createSpy('totalVariants').andReturn('variants total')
      EnterpriseFee =
        index: jasmine.createSpy('index').andReturn('enterprise fees list')
        forEnterprise: jasmine.createSpy('forEnterprise').andReturn('enterprise fees for enterprise')

      module('order_cycle')
      inject ($controller) ->
        ctrl = $controller 'AdminCreateOrderCycleCtrl', {$scope: scope, OrderCycle: OrderCycle, Enterprise: Enterprise, EnterpriseFee: EnterpriseFee}


    it 'Loads enterprises and supplied products', ->
      expect(Enterprise.index).toHaveBeenCalled()
      expect(scope.enterprises).toEqual('enterprises list')
      expect(scope.supplied_products).toEqual('supplied products')

    it 'Loads enterprise fees', ->
      expect(EnterpriseFee.index).toHaveBeenCalled()
      expect(scope.enterprise_fees).toEqual('enterprise fees list')

    it 'Loads order cycles', ->
      expect(scope.order_cycle).toEqual('my order cycle')

    describe 'Reporting when all resources are loaded', ->
      it 'returns true when Enterprise and EnterpriseFee are loaded', ->
        Enterprise.loaded = EnterpriseFee.loaded = true
        expect(scope.loaded()).toBe(true)

      it 'returns false otherwise', ->
        Enterprise.loaded = true
        EnterpriseFee.loaded = false
        expect(scope.loaded()).toBe(false)

    it "delegates suppliedVariants to Enterprise", ->
      expect(scope.suppliedVariants('enterprise_id')).toEqual('supplied variants')
      expect(Enterprise.suppliedVariants).toHaveBeenCalledWith('enterprise_id')

    it 'Delegates exchangeSelectedVariants to OrderCycle', ->
      expect(scope.exchangeSelectedVariants('exchange')).toEqual('variants selected')
      expect(OrderCycle.exchangeSelectedVariants).toHaveBeenCalledWith('exchange')

    it "delegates setExchangeVariants to OrderCycle", ->
      scope.setExchangeVariants('exchange', 'variants', 'selected')
      expect(OrderCycle.setExchangeVariants).toHaveBeenCalledWith('exchange', 'variants', 'selected')

    it 'Delegates enterpriseTotalVariants to Enterprise', ->
      expect(scope.enterpriseTotalVariants('enterprise')).toEqual('variants total')
      expect(Enterprise.totalVariants).toHaveBeenCalledWith('enterprise')

    it 'Delegates productSuppliedToOrderCycle to OrderCycle', ->
      expect(scope.productSuppliedToOrderCycle('product')).toEqual('product supplied')
      expect(OrderCycle.productSuppliedToOrderCycle).toHaveBeenCalledWith('product')

    it 'Delegates variantSuppliedToOrderCycle to OrderCycle', ->
      expect(scope.variantSuppliedToOrderCycle('variant')).toEqual('variant supplied')
      expect(OrderCycle.variantSuppliedToOrderCycle).toHaveBeenCalledWith('variant')

    it 'Delegates exchangeDirection to OrderCycle', ->
      expect(scope.exchangeDirection('exchange')).toEqual('exchange direction')
      expect(OrderCycle.exchangeDirection).toHaveBeenCalledWith('exchange')

    it 'Finds enterprises participating in the order cycle', ->
      scope.enterprises =
        1: {id: 1, name: 'Eaterprises'}
        2: {id: 2, name: 'Pepper Tree Place'}
      OrderCycle.participatingEnterpriseIds = jasmine.createSpy('participatingEnterpriseIds').andReturn([2])
      expect(scope.participatingEnterprises()).toEqual([
        {id: 2, name: 'Pepper Tree Place'}
        ])

    it 'Delegates toggleProducts to OrderCycle', ->
      scope.toggleProducts(event, 'exchange')
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.toggleProducts).toHaveBeenCalledWith('exchange')

    it 'Delegates enterpriseFeesForEnterprise to EnterpriseFee', ->
      scope.enterpriseFeesForEnterprise('123')
      expect(EnterpriseFee.forEnterprise).toHaveBeenCalledWith(123)

    it 'Adds order cycle suppliers', ->
      scope.new_supplier_id = 'new supplier id'
      scope.addSupplier(event)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.addSupplier).toHaveBeenCalledWith('new supplier id')

    it 'Adds order cycle distributors', ->
      scope.new_distributor_id = 'new distributor id'
      scope.addDistributor(event)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.addDistributor).toHaveBeenCalledWith('new distributor id')

    it 'Removes order cycle exchanges', ->
      scope.removeExchange(event, 'exchange')
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.removeExchange).toHaveBeenCalledWith('exchange')

    it 'Adds coordinator fees', ->
      scope.addCoordinatorFee(event)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.addCoordinatorFee).toHaveBeenCalled()

    it 'Removes coordinator fees', ->
      scope.removeCoordinatorFee(event, 0)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.removeCoordinatorFee).toHaveBeenCalledWith(0)

    it 'Adds exchange fees', ->
      scope.addExchangeFee(event)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.addExchangeFee).toHaveBeenCalled()

    it 'Removes exchange fees', ->
      scope.removeExchangeFee(event, 'exchange', 0)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.removeExchangeFee).toHaveBeenCalledWith('exchange', 0)

    it 'Removes distribution of a variant', ->
      scope.removeDistributionOfVariant('variant')
      expect(OrderCycle.removeDistributionOfVariant).toHaveBeenCalledWith('variant')

    it 'Submits the order cycle via OrderCycle create', ->
      scope.submit()
      expect(OrderCycle.create).toHaveBeenCalled()

  describe 'AdminEditOrderCycleCtrl', ->
    ctrl = null
    scope = null
    event = null
    location = null
    OrderCycle = null
    Enterprise = null
    EnterpriseFee = null

    beforeEach ->
      scope = {}
      event =
        preventDefault: jasmine.createSpy('preventDefault')
      location =
        absUrl: ->
          'example.com/admin/order_cycles/27/edit'
      OrderCycle =
        load: jasmine.createSpy('load')
        exchangeSelectedVariants: jasmine.createSpy('exchangeSelectedVariants').andReturn('variants selected')
        productSuppliedToOrderCycle: jasmine.createSpy('productSuppliedToOrderCycle').andReturn('product supplied')
        variantSuppliedToOrderCycle: jasmine.createSpy('variantSuppliedToOrderCycle').andReturn('variant supplied')
        exchangeDirection: jasmine.createSpy('exchangeDirection').andReturn('exchange direction')
        toggleProducts: jasmine.createSpy('toggleProducts')
        setExchangeVariants: jasmine.createSpy('setExchangeVariants')
        addSupplier: jasmine.createSpy('addSupplier')
        addDistributor: jasmine.createSpy('addDistributor')
        removeExchange: jasmine.createSpy('removeExchange')
        addCoordinatorFee: jasmine.createSpy('addCoordinatorFee')
        removeCoordinatorFee: jasmine.createSpy('removeCoordinatorFee')
        addExchangeFee: jasmine.createSpy('addExchangeFee')
        removeExchangeFee: jasmine.createSpy('removeExchangeFee')
        removeDistributionOfVariant: jasmine.createSpy('removeDistributionOfVariant')
        update: jasmine.createSpy('update')
      Enterprise =
        index: jasmine.createSpy('index').andReturn('enterprises list')
        supplied_products: 'supplied products'
        suppliedVariants: jasmine.createSpy('suppliedVariants').andReturn('supplied variants')
        totalVariants: jasmine.createSpy('totalVariants').andReturn('variants total')
      EnterpriseFee =
        index: jasmine.createSpy('index').andReturn('enterprise fees list')
        forEnterprise: jasmine.createSpy('forEnterprise').andReturn('enterprise fees for enterprise')

      module('order_cycle')
      inject ($controller) ->
        ctrl = $controller 'AdminEditOrderCycleCtrl', {$scope: scope, $location: location, OrderCycle: OrderCycle, Enterprise: Enterprise, EnterpriseFee: EnterpriseFee}

    it 'Loads enterprises and supplied products', ->
      expect(Enterprise.index).toHaveBeenCalled()
      expect(scope.enterprises).toEqual('enterprises list')
      expect(scope.supplied_products).toEqual('supplied products')

    it 'Loads enterprise fees', ->
      expect(EnterpriseFee.index).toHaveBeenCalled()
      expect(scope.enterprise_fees).toEqual('enterprise fees list')

    it 'Loads order cycles', ->
      expect(OrderCycle.load).toHaveBeenCalledWith('27')

    describe 'Reporting when all resources are loaded', ->
      it 'returns true when Enterprise, EnterpriseFee and OrderCycle are loaded', ->
        Enterprise.loaded = EnterpriseFee.loaded = OrderCycle.loaded = true
        expect(scope.loaded()).toBe(true)

      it 'returns false otherwise', ->
        Enterprise.loaded = true
        EnterpriseFee.loaded = true
        OrderCycle.loaded = false
        expect(scope.loaded()).toBe(false)

    it "delegates suppliedVariants to Enterprise", ->
      expect(scope.suppliedVariants('enterprise_id')).toEqual('supplied variants')
      expect(Enterprise.suppliedVariants).toHaveBeenCalledWith('enterprise_id')

    it 'Delegates exchangeSelectedVariants to OrderCycle', ->
      expect(scope.exchangeSelectedVariants('exchange')).toEqual('variants selected')
      expect(OrderCycle.exchangeSelectedVariants).toHaveBeenCalledWith('exchange')

    it "delegates setExchangeVariants to OrderCycle", ->
      scope.setExchangeVariants('exchange', 'variants', 'selected')
      expect(OrderCycle.setExchangeVariants).toHaveBeenCalledWith('exchange', 'variants', 'selected')

    it 'Delegates totalVariants to Enterprise', ->
      expect(scope.enterpriseTotalVariants('enterprise')).toEqual('variants total')
      expect(Enterprise.totalVariants).toHaveBeenCalledWith('enterprise')

    it 'Delegates productSuppliedToOrderCycle to OrderCycle', ->
      expect(scope.productSuppliedToOrderCycle('product')).toEqual('product supplied')
      expect(OrderCycle.productSuppliedToOrderCycle).toHaveBeenCalledWith('product')

    it 'Delegates variantSuppliedToOrderCycle to OrderCycle', ->
      expect(scope.variantSuppliedToOrderCycle('variant')).toEqual('variant supplied')
      expect(OrderCycle.variantSuppliedToOrderCycle).toHaveBeenCalledWith('variant')

    it 'Delegates exchangeDirection to OrderCycle', ->
      expect(scope.exchangeDirection('exchange')).toEqual('exchange direction')
      expect(OrderCycle.exchangeDirection).toHaveBeenCalledWith('exchange')

    it 'Finds enterprises participating in the order cycle', ->
      scope.enterprises =
        1: {id: 1, name: 'Eaterprises'}
        2: {id: 2, name: 'Pepper Tree Place'}
      OrderCycle.participatingEnterpriseIds = jasmine.createSpy('participatingEnterpriseIds').andReturn([2])
      expect(scope.participatingEnterprises()).toEqual([
        {id: 2, name: 'Pepper Tree Place'}
        ])

    it 'Delegates toggleProducts to OrderCycle', ->
      scope.toggleProducts(event, 'exchange')
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.toggleProducts).toHaveBeenCalledWith('exchange')

    it 'Delegates enterpriseFeesForEnterprise to EnterpriseFee', ->
      scope.enterpriseFeesForEnterprise('123')
      expect(EnterpriseFee.forEnterprise).toHaveBeenCalledWith(123)

    it 'Adds order cycle suppliers', ->
      scope.new_supplier_id = 'new supplier id'
      scope.addSupplier(event)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.addSupplier).toHaveBeenCalledWith('new supplier id')

    it 'Adds order cycle distributors', ->
      scope.new_distributor_id = 'new distributor id'
      scope.addDistributor(event)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.addDistributor).toHaveBeenCalledWith('new distributor id')

    it 'Removes order cycle exchanges', ->
      scope.removeExchange(event, 'exchange')
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.removeExchange).toHaveBeenCalledWith('exchange')

    it 'Adds coordinator fees', ->
      scope.addCoordinatorFee(event)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.addCoordinatorFee).toHaveBeenCalled()

    it 'Removes coordinator fees', ->
      scope.removeCoordinatorFee(event, 0)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.removeCoordinatorFee).toHaveBeenCalledWith(0)

    it 'Adds exchange fees', ->
      scope.addExchangeFee(event)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.addExchangeFee).toHaveBeenCalled()

    it 'Removes exchange fees', ->
      scope.removeExchangeFee(event, 'exchange', 0)
      expect(event.preventDefault).toHaveBeenCalled()
      expect(OrderCycle.removeExchangeFee).toHaveBeenCalledWith('exchange', 0)

    it 'Removes distribution of a variant', ->
      scope.removeDistributionOfVariant('variant')
      expect(OrderCycle.removeDistributionOfVariant).toHaveBeenCalledWith('variant')

    it 'Submits the order cycle via OrderCycle update', ->
      scope.submit()
      expect(OrderCycle.update).toHaveBeenCalled()


describe 'OrderCycle services', ->
  describe 'Enterprise service', ->
    $httpBackend = null
    Enterprise = null

    beforeEach ->
      module 'order_cycle'
      inject ($injector, _$httpBackend_)->
        Enterprise = $injector.get('Enterprise')
        $httpBackend = _$httpBackend_
        $httpBackend.whenGET('/admin/enterprises.json').respond [
          {id: 1, name: 'One', supplied_products: [1, 2]}
          {id: 2, name: 'Two', supplied_products: [3, 4]}
          {id: 3, name: 'Three', supplied_products: [5, 6]}
          ]

    it 'loads enterprises as a hash', ->
      enterprises = Enterprise.index()
      $httpBackend.flush()
      expect(enterprises).toEqual
        1: new Enterprise.Enterprise({id: 1, name: 'One', supplied_products: [1, 2]})
        2: new Enterprise.Enterprise({id: 2, name: 'Two', supplied_products: [3, 4]})
        3: new Enterprise.Enterprise({id: 3, name: 'Three', supplied_products: [5, 6]})

    it 'reports its loadedness', ->
      expect(Enterprise.loaded).toBe(false)
      Enterprise.index()
      $httpBackend.flush()
      expect(Enterprise.loaded).toBe(true)

    it 'collates all supplied products', ->
      enterprises = Enterprise.index()
      $httpBackend.flush()
      expect(Enterprise.supplied_products).toEqual [1, 2, 3, 4, 5, 6]

    it "finds supplied variants for an enterprise", ->
      spyOn(Enterprise, 'variantsOf').andReturn(10)
      Enterprise.index()
      $httpBackend.flush()
      expect(Enterprise.suppliedVariants(1)).toEqual [10, 10]

    describe "finding the variants of a product", ->
      it "returns the master for products without variants", ->
        p =
          master_id: 1
          variants: []
        expect(Enterprise.variantsOf(p)).toEqual [1]

      it "returns the variant ids for products with variants", ->
        p =
          master_id: 1
          variants: [{id: 2}, {id: 3}]
        expect(Enterprise.variantsOf(p)).toEqual [2, 3]

    it 'counts total variants supplied by an enterprise', ->
      enterprise =
        supplied_products: [
          {variants: []},
          {variants: []},
          {variants: [{}, {}, {}]}
          ]

      expect(Enterprise.totalVariants(enterprise)).toEqual(5)

    it 'returns zero when enterprise is null', ->
      expect(Enterprise.totalVariants(null)).toEqual(0)

  describe 'EnterpriseFee service', ->
    $httpBackend = null
    EnterpriseFee = null

    beforeEach ->
      module 'order_cycle'
      inject ($injector, _$httpBackend_)->
        EnterpriseFee = $injector.get('EnterpriseFee')
        $httpBackend = _$httpBackend_
        $httpBackend.whenGET('/admin/enterprise_fees.json').respond [
          {id: 1, name: "Yayfee", enterprise_id: 1}
          {id: 2, name: "FeeTwo", enterprise_id: 2}
          ]

    it 'loads enterprise fees', ->
      enterprise_fees = EnterpriseFee.index()
      $httpBackend.flush()
      expect(enterprise_fees).toEqual [
        new EnterpriseFee.EnterpriseFee({id: 1, name: "Yayfee", enterprise_id: 1})
        new EnterpriseFee.EnterpriseFee({id: 2, name: "FeeTwo", enterprise_id: 2})
        ]

    it 'reports its loadedness', ->
      expect(EnterpriseFee.loaded).toBe(false)
      EnterpriseFee.index()
      $httpBackend.flush()
      expect(EnterpriseFee.loaded).toBe(true)

    it 'returns enterprise fees for an enterprise', ->
      all_enterprise_fees = EnterpriseFee.index()
      $httpBackend.flush()
      enterprise_fees = EnterpriseFee.forEnterprise(1)
      expect(enterprise_fees).toEqual [
        new EnterpriseFee.EnterpriseFee({id: 1, name: "Yayfee", enterprise_id: 1})
        ]


  describe 'OrderCycle service', ->
    OrderCycle = null
    $httpBackend = null
    $window = null

    beforeEach ->
      $window = {navigator: {userAgent: 'foo'}}

      module 'order_cycle', ($provide)->
        $provide.value('$window', $window)
        null

      inject ($injector, _$httpBackend_)->
        OrderCycle = $injector.get('OrderCycle')
        $httpBackend = _$httpBackend_
        $httpBackend.whenGET('/admin/order_cycles/123.json').respond
          id: 123
          name: 'Test Order Cycle'
          coordinator_id: 456
          coordinator_fees: []
          exchanges: [
            {sender_id: 1, receiver_id: 456, incoming: true}
            {sender_id: 456, receiver_id: 2, incoming: false}
            ]

    it 'initialises order cycle', ->
      expect(OrderCycle.order_cycle).toEqual
        incoming_exchanges: []
        outgoing_exchanges: []
        coordinator_fees: []

    it 'counts selected variants in an exchange', ->
      result = OrderCycle.exchangeSelectedVariants({variants: {1: true, 2: false, 3: true}})
      expect(result).toEqual(2)

    describe 'fetching the direction for an exchange', ->
      it 'returns "incoming" for incoming exchanges', ->
        exchange = {id: 1}
        OrderCycle.order_cycle.incoming_exchanges = [exchange]
        OrderCycle.order_cycle.outgoing_exchanges = []
        expect(OrderCycle.exchangeDirection(exchange)).toEqual 'incoming'

      it 'returns "outgoing" for outgoing exchanges', ->
        exchange = {id: 1}
        OrderCycle.order_cycle.incoming_exchanges = []
        OrderCycle.order_cycle.outgoing_exchanges = [exchange]
        expect(OrderCycle.exchangeDirection(exchange)).toEqual 'outgoing'

    describe 'toggling products', ->
      exchange = null

      beforeEach ->
        exchange = {}

      it 'sets a blank value to true', ->
        OrderCycle.toggleProducts(exchange)
        expect(exchange.showProducts).toEqual(true)

      it 'sets a true value to false', ->
        exchange.showProducts = true
        OrderCycle.toggleProducts(exchange)
        expect(exchange.showProducts).toEqual(false)

      it 'sets a false value to true', ->
        exchange.showProducts = false
        OrderCycle.toggleProducts(exchange)
        expect(exchange.showProducts).toEqual(true)

    describe "setting exchange variants", ->
      it "sets all variants to the provided value", ->
        exchange = {variants: {2: false}}
        OrderCycle.setExchangeVariants(exchange, [1, 2, 3], true)
        expect(exchange.variants).toEqual {1: true, 2: true, 3: true}

    describe 'adding suppliers', ->
      exchange = null

      it 'adds the supplier to incoming exchanges', ->
        OrderCycle.addSupplier('123')
        expect(OrderCycle.order_cycle.incoming_exchanges).toEqual [
          {enterprise_id: '123', incoming: true, active: true, variants: {}, enterprise_fees: []}
        ]

    describe 'adding distributors', ->
      exchange = null

      it 'adds the distributor to outgoing exchanges', ->
        OrderCycle.addDistributor('123')
        expect(OrderCycle.order_cycle.outgoing_exchanges).toEqual [
          {enterprise_id: '123', incoming: false, active: true, variants: {}, enterprise_fees: []}
        ]

    describe 'removing exchanges', ->
      it 'removes incoming exchanges', ->
        exchange = {enterprise_id: '123', active: true, variants: {}, enterprise_fees: []}
        OrderCycle.order_cycle.incoming_exchanges = [exchange]
        OrderCycle.removeExchange(exchange)
        expect(OrderCycle.order_cycle.incoming_exchanges).toEqual []

      it 'removes outgoing exchanges', ->
        exchange = {enterprise_id: '123', active: true, variants: {}, enterprise_fees: []}
        OrderCycle.order_cycle.outgoing_exchanges = [exchange]
        OrderCycle.removeExchange(exchange)
        expect(OrderCycle.order_cycle.outgoing_exchanges).toEqual []

      it 'removes distribution of all exchange variants', ->
        spyOn(OrderCycle, 'removeDistributionOfVariant')
        exchange =
          enterprise_id: '123'
          active: true
          variants: {1: true, 2: false, 3: true}
          enterprise_fees: []
        OrderCycle.order_cycle.incoming_exchanges = [exchange]
        OrderCycle.removeExchange(exchange)
        expect(OrderCycle.removeDistributionOfVariant).toHaveBeenCalledWith('1')
        expect(OrderCycle.removeDistributionOfVariant).not.toHaveBeenCalledWith('2')
        expect(OrderCycle.removeDistributionOfVariant).toHaveBeenCalledWith('3')

    it 'adds coordinator fees', ->
      OrderCycle.addCoordinatorFee()
      expect(OrderCycle.order_cycle.coordinator_fees).toEqual [{}]

    describe 'removing coordinator fees', ->
      it 'removes a coordinator fee by index', ->
        OrderCycle.order_cycle.coordinator_fees = [
          {id: 1}
          {id: 2}
          {id: 3}
          ]
        OrderCycle.removeCoordinatorFee(1)
        expect(OrderCycle.order_cycle.coordinator_fees).toEqual [
          {id: 1}
          {id: 3}
          ]

    it 'adds exchange fees', ->
      exchange = {enterprise_fees: []}
      OrderCycle.addExchangeFee(exchange)
      expect(exchange.enterprise_fees).toEqual [{}]

    describe 'removing exchange fees', ->
      it 'removes an exchange fee by index', ->
        exchange =
          enterprise_fees: [
            {id: 1}
            {id: 2}
            {id: 3}
            ]
        OrderCycle.removeExchangeFee(exchange, 1)
        expect(exchange.enterprise_fees).toEqual [
          {id: 1}
          {id: 3}
          ]

    it 'finds participating enterprise ids', ->
      OrderCycle.order_cycle.incoming_exchanges = [
        {enterprise_id: 1}
        {enterprise_id: 2}
      ]
      OrderCycle.order_cycle.outgoing_exchanges = [
        {enterprise_id: 2}
        {enterprise_id: 3}
      ]
      expect(OrderCycle.participatingEnterpriseIds()).toEqual [1, 2, 3]

    describe 'fetching all variants supplied on incoming exchanges', ->
      it 'collects variants from incoming exchanges', ->
        OrderCycle.order_cycle.incoming_exchanges = [
          {variants: {1: true, 2: false}}
          {variants: {3: false, 4: true}}
          {variants: {5: true, 6: false}}
        ]
        expect(OrderCycle.incomingExchangesVariants()).toEqual [1, 4, 5]

    describe 'checking whether a product is supplied to the order cycle', ->
      product_master_present = product_variant_present = product_master_absent = product_variant_absent = null

      beforeEach ->
        product_master_present =
          name: "Linseed (500g)"
          master_id: 1
          variants: []
        product_variant_present =
          name: "Linseed (500g)"
          master_id: 2
          variants: [{id: 3}, {id: 4}]
        product_master_absent =
          name: "Linseed (500g)"
          master_id: 5
          variants: []
        product_variant_absent =
          name: "Linseed (500g)"
          master_id: 6
          variants: [{id: 7}, {id: 8}]

        spyOn(OrderCycle, 'incomingExchangesVariants').andReturn([1, 3])

      it 'returns true for products whose master is supplied', ->
        expect(OrderCycle.productSuppliedToOrderCycle(product_master_present)).toBeTruthy()

      it 'returns true for products for whom a variant is supplied', ->
        expect(OrderCycle.productSuppliedToOrderCycle(product_variant_present)).toBeTruthy()

      it 'returns false for products whose master is not supplied', ->
        expect(OrderCycle.productSuppliedToOrderCycle(product_master_absent)).toBeFalsy()

      it 'returns false for products whose variants are not supplied', ->
        expect(OrderCycle.productSuppliedToOrderCycle(product_variant_absent)).toBeFalsy()


    describe 'checking whether a variant is supplied to the order cycle', ->
      beforeEach ->
        spyOn(OrderCycle, 'incomingExchangesVariants').andReturn([1, 3])

      it 'returns true for variants that are supplied', ->
        expect(OrderCycle.variantSuppliedToOrderCycle({id: 1})).toBeTruthy()

      it 'returns false for variants that are not supplied', ->
        expect(OrderCycle.variantSuppliedToOrderCycle({id: 999})).toBeFalsy()


    describe 'remove all distribution of a variant', ->
      it 'removes the variant from every outgoing exchange', ->
        OrderCycle.order_cycle.outgoing_exchanges = [
          {variants: {123: true, 234: true}}
          {variants: {123: true, 333: true}}
        ]
        OrderCycle.removeDistributionOfVariant('123')
        expect(OrderCycle.order_cycle.outgoing_exchanges).toEqual [
          {variants: {123: false, 234: true}}
          {variants: {123: false, 333: true}}
        ]

    describe 'loading an order cycle, reporting loadedness', ->
      it 'reports its loadedness', ->
        expect(OrderCycle.loaded).toBe(false)
        OrderCycle.load('123')
        $httpBackend.flush()
        expect(OrderCycle.loaded).toBe(true)

    describe 'loading an order cycle', ->
      beforeEach ->
        OrderCycle.load('123')
        $httpBackend.flush()

      it 'loads basic fields', ->
        expect(OrderCycle.order_cycle.id).toEqual(123)
        expect(OrderCycle.order_cycle.name).toEqual('Test Order Cycle')
        expect(OrderCycle.order_cycle.coordinator_id).toEqual(456)

      it 'splits exchanges into incoming and outgoing', ->
        expect(OrderCycle.order_cycle.incoming_exchanges).toEqual [
          sender_id: 1
          enterprise_id: 1
          incoming: true
          active: true
          ]

        expect(OrderCycle.order_cycle.outgoing_exchanges).toEqual [
          receiver_id: 2
          enterprise_id: 2
          incoming: false
          active: true
          ]

      it 'removes original exchanges array', ->
        expect(OrderCycle.order_cycle.exchanges).toEqual(undefined)

    describe 'creating an order cycle', ->
      it 'redirects to the order cycles page on success', ->
        OrderCycle.order_cycle = 'this is the order cycle'
        spyOn(OrderCycle, 'dataForSubmit').andReturn('this is the submit data')
        $httpBackend.expectPOST('/admin/order_cycles.json', {
          order_cycle: 'this is the submit data'
          }).respond {success: true}

        OrderCycle.create()
        $httpBackend.flush()
        expect($window.location).toEqual('/admin/order_cycles')

      it 'does not redirect on error', ->
        OrderCycle.order_cycle = 'this is the order cycle'
        spyOn(OrderCycle, 'dataForSubmit').andReturn('this is the submit data')
        $httpBackend.expectPOST('/admin/order_cycles.json', {
          order_cycle: 'this is the submit data'
          }).respond {success: false}

        OrderCycle.create()
        $httpBackend.flush()
        expect($window.location).toEqual(undefined)

    describe 'updating an order cycle', ->
      it 'redirects to the order cycles page on success', ->
        OrderCycle.order_cycle = 'this is the order cycle'
        spyOn(OrderCycle, 'dataForSubmit').andReturn('this is the submit data')
        $httpBackend.expectPUT('/admin/order_cycles.json', {
          order_cycle: 'this is the submit data'
          }).respond {success: true}

        OrderCycle.update()
        $httpBackend.flush()
        expect($window.location).toEqual('/admin/order_cycles')

      it 'does not redirect on error', ->
        OrderCycle.order_cycle = 'this is the order cycle'
        spyOn(OrderCycle, 'dataForSubmit').andReturn('this is the submit data')
        $httpBackend.expectPUT('/admin/order_cycles.json', {
          order_cycle: 'this is the submit data'
          }).respond {success: false}

        OrderCycle.update()
        $httpBackend.flush()
        expect($window.location).toEqual(undefined)

    describe 'preparing data for form submission', ->
      it 'calls all the methods', ->
        OrderCycle.order_cycle = {foo: 'bar'}
        spyOn(OrderCycle, 'removeInactiveExchanges')
        spyOn(OrderCycle, 'translateCoordinatorFees')
        spyOn(OrderCycle, 'translateExchangeFees')
        OrderCycle.dataForSubmit()
        expect(OrderCycle.removeInactiveExchanges).toHaveBeenCalled()
        expect(OrderCycle.translateCoordinatorFees).toHaveBeenCalled()
        expect(OrderCycle.translateExchangeFees).toHaveBeenCalled()

      it 'removes inactive exchanges', ->
        data =
          incoming_exchanges: [
            {enterprise_id: "1", active: false}
            {enterprise_id: "2", active: true}
            {enterprise_id: "3", active: false}
            ]
          outgoing_exchanges: [
            {enterprise_id: "4", active: true}
            {enterprise_id: "5", active: false}
            {enterprise_id: "6", active: true}
            ]

        data = OrderCycle.removeInactiveExchanges(data)

        expect(data.incoming_exchanges).toEqual [
          {enterprise_id: "2", active: true}
          ]
        expect(data.outgoing_exchanges).toEqual [
          {enterprise_id: "4", active: true}
          {enterprise_id: "6", active: true}
          ]

      it 'converts coordinator fees into a list of ids', ->
        order_cycle =
          coordinator_fees: [
            {id: 1}
            {id: 2}
            ]

        data = OrderCycle.translateCoordinatorFees(order_cycle)

        expect(data.coordinator_fees).toBeUndefined()
        expect(data.coordinator_fee_ids).toEqual [1, 2]

      it "preserves original data when converting coordinator fees", ->
       OrderCycle.order_cycle =
          coordinator_fees: [
            {id: 1}
            {id: 2}
            ]

        data = OrderCycle.deepCopy()
        data = OrderCycle.translateCoordinatorFees(data)

        expect(OrderCycle.order_cycle.coordinator_fees).toEqual [{id: 1}, {id: 2}]
        expect(OrderCycle.order_cycle.coordinator_fee_ids).toBeUndefined()

      describe "converting exchange fees into a list of ids", ->
        order_cycle = null
        data = null

        beforeEach ->
          order_cycle =
            incoming_exchanges: [
              enterprise_fees: [
                {id: 1}
                {id: 2}
              ]
            ]
            outgoing_exchanges: [
              enterprise_fees: [
                {id: 3}
                {id: 4}
              ]
            ]
          OrderCycle.order_cycle = order_cycle

          data = OrderCycle.deepCopy()
          data = OrderCycle.translateExchangeFees(data)

        it 'converts exchange fees into a list of ids', ->
          expect(data.incoming_exchanges[0].enterprise_fees).toBeUndefined()
          expect(data.outgoing_exchanges[0].enterprise_fees).toBeUndefined()
          expect(data.incoming_exchanges[0].enterprise_fee_ids).toEqual [1, 2]
          expect(data.outgoing_exchanges[0].enterprise_fee_ids).toEqual [3, 4]

        it "preserves original data when converting exchange fees", ->
          expect(order_cycle.incoming_exchanges[0].enterprise_fees).toEqual [{id: 1}, {id: 2}]
          expect(order_cycle.outgoing_exchanges[0].enterprise_fees).toEqual [{id: 3}, {id: 4}]
          expect(order_cycle.incoming_exchanges[0].enterprise_fee_ids).toBeUndefined()
          expect(order_cycle.outgoing_exchanges[0].enterprise_fee_ids).toBeUndefined()
  