pragma solidity >=0.4.24;

import '../Ownable.sol';
import '../FarmerActor.sol';
import '../DistributorActor.sol';
import '../RetailerActor.sol';
import '../ConsumerActor.sol';
import '../WarehouseActor.sol';

contract ProductChainManagement is Ownable,FarmerActor,DistributorActor,RetailerActor,ConsumerActor,WarehouseActor{
    address owner;
    uint  ProductCode;
	  uint  LocalProductCode;
    mapping (uint => Product) products;
	  mapping (uint => Txblocks) ProductsHistory;

    enum State{
        ProduceByFarmer,  //0
        ForSaleByFarmer,  //1
        PurchasedByDistributor,  //2
        ShippedByFarmer,  //3
        ReceivedByDistributor,  //4
        ShippedToWarehouse,  //5
        ReceivedByWarehouse,  //6
        ProcessedByDistributor,  //7
        PackageByDistributor,  //8
        ForSaleByDistributor,  //9
        PurchasedByRetailer,  //10
        ShippedByDistributor,  //11
        ShippedFromWarehouse,  //12
        ReceivedByRetailer,  //13
        ForSaleByRetailer,  //14
        PurchasedByConsumer  //15
    }

    State constant defaultState = State.ProduceByFarmer;

    struct Product{
        uint LocalProductCode;
        uint ProductCode; 
        uint ProductID;
        address ownerID;
        address FarmerID;
        State ProductState;
        address DistributorID;
        address RetailerID;
        address ConsumerID;
        address WarehouseID;
    }

    struct Txblocks{
        uint blockFarmerToDistributor;
		uint blockDistributorToWarehouse;
		uint blockWarehouseToRetailer;
		uint blockDistributorToRetailer;
        uint blockRetailerToConsumer;
    }

    event ProduceByFarmer(uint LocalProductCode);  //0
    event ForSaleByFarmer(uint LocalProductCode);  //1
    event PurchasedByDistributor(uint LocalProductCode);  //2
    event ShippedByFarmer(uint LocalProductCode);  //3
    event ReceivedByDistributor(uint LocalProductCode);  //4
    event ShippedToWarehouse(uint LocalProductCode);  //5
    event ReceivedByWarehouse(uint LocalProductCode);  //6
    event ProcessedByDistributor(uint LocalProductCode);  //7
    event PackageByDistributor(uint LocalProductCode);  //8
    event ForSaleByDistributor(uint LocalProductCode);  //9
    event PurchasedByRetailer(uint LocalProductCode);  //10
    event ShippedByDistributor(uint LocalProductCode);  //11
    event ShippedFromWarehouse(uint LocalProductCode);  //12
    event ReceivedByRetailer(uint LocalProductCode);  //13
    event ForSaleByRetailer(uint LocalProductCode);  //14
    event PurchasedByConsumer(uint LocalProductCode);  //15

  modifier verifyCaller (address _address) 
		{
		require(msg.sender == _address);
		_;
		}
    modifier produceByFarmer(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ProduceByFarmer);
		_;
		}
    modifier forSaleByFarmer(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ForSaleByFarmer);
		_;
		}
    modifier purchasedByDistributor(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.PurchasedByDistributor);
		_;
		}
    modifier shippedByFarmer(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ShippedByFarmer);
		_;
		}
    modifier receivedByDistributor(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ReceivedByDistributor);
		_;
		}
    modifier shippedToWarehouse(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ShippedToWarehouse);
		_;
		}
    modifier receivedByWarehouse(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ReceivedByWarehouse);
		_;
		}
    modifier processedByDistributor(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ProcessedByDistributor);
		_;
		}
    modifier packageByDistributor(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.PackageByDistributor);
		_;
		}
    modifier forSaleByDistributor(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ForSaleByDistributor);
		_;
		}
    modifier purchasedByRetailer(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.PurchasedByRetailer);
		_;
		}
    modifier shippedByDistributor(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ShippedByDistributor);
		_;
		}
    modifier shippedFromWarehouse(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ShippedFromWarehouse);
		_;
		}
    modifier receivedByRetailer(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ReceivedByRetailer);
		_;
		}
    modifier forSaleByRetailer(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.ForSaleByRetailer);
		_;
		}
    modifier purchasedByConsumer(uint _LocalProductCode) 
		{
		require(products[_LocalProductCode].ProductState == State.PurchasedByConsumer);
		_;
		}


    function produceProductByFarmer(uint _LocalProductCode) public payable onlyFarmer(){
        address DistributorID;
        address RetailerID;
        address ConsumerID;
        address WarehouseID;
        Product memory newProduce;
        newProduce.ProductCode = ProductCode;
        newProduce.LocalProductCode = _LocalProductCode;
        newProduce.ownerID = msg.sender;
        newProduce.ProductID = _LocalProductCode + ProductCode;
        newProduce.ProductState = defaultState; 
        newProduce.DistributorID = DistributorID; 
        newProduce.RetailerID = RetailerID; 
        newProduce.ConsumerID = ConsumerID;
        newProduce.WarehouseID = WarehouseID;
        products[_LocalProductCode] = newProduce;
        Txblocks memory txBlock;
        uint placeholder;
        txBlock.blockFarmerToDistributor = placeholder; 
        txBlock.blockDistributorToWarehouse = placeholder;
        txBlock.blockWarehouseToRetailer = placeholder;
        txBlock.blockDistributorToRetailer = placeholder;
        txBlock.blockRetailerToConsumer = placeholder;
        ProductsHistory[_LocalProductCode] = txBlock;

        ProductCode = ProductCode + 1;
	    emit ProduceByFarmer(_LocalProductCode);
    }

    function sellProductByFarmer(uint _LocalProductCode) public payable 
    onlyFarmer() 
    produceByFarmer(_LocalProductCode)
   
    {
      products[_LocalProductCode].ProductState = State.ForSaleByFarmer;
      emit ForSaleByFarmer(_LocalProductCode);
    }

    function purchaseProductByDistributor(uint _LocalProductCode) public payable 
    onlyDistributor() 
    forSaleByFarmer(_LocalProductCode){
      products[_LocalProductCode].ownerID = msg.sender; 
      products[_LocalProductCode].DistributorID = msg.sender;
      products[_LocalProductCode].ProductState = State.PurchasedByDistributor; 
      ProductsHistory[_LocalProductCode].blockFarmerToDistributor = block.number;
      emit PurchasedByDistributor(_LocalProductCode);
    }

    function shippedProductByFarmer(uint _LocalProductCode) public payable 
    onlyFarmer() 
    purchasedByDistributor(_LocalProductCode)
    
    {
      products[_LocalProductCode].ProductState = State.ShippedByFarmer;
      emit ShippedByFarmer(_LocalProductCode);
    }

    function receivedProductByDistributor(uint _LocalProductCode) public payable 
    onlyDistributor() 
    shippedByFarmer(_LocalProductCode)
    
    {
      products[_LocalProductCode].ProductState = State.ReceivedByDistributor;
      emit ReceivedByDistributor(_LocalProductCode);
    }

    function shippedProductFromWarehouse(uint _LocalProductCode) public payable 
    onlyDistributor() 
    receivedByDistributor(_LocalProductCode)
    
    {
        products[_LocalProductCode].ownerID = msg.sender; 
        products[_LocalProductCode].WarehouseID = msg.sender;
        products[_LocalProductCode].ProductState = State.ShippedToWarehouse;
        ProductsHistory[_LocalProductCode].blockDistributorToWarehouse = block.number; 
        emit ShippedToWarehouse(_LocalProductCode);
    }

    function receivedProductByWarehouse(uint _LocalProductCode) public payable 
    onlyWarehouse()
    shippedToWarehouse(_LocalProductCode)
    
    {
      products[_LocalProductCode].ProductState = State.ReceivedByWarehouse;
      emit ReceivedByWarehouse(_LocalProductCode);
    }

    function processedProductByDistributor(uint _LocalProductCode) public payable 
    onlyDistributor() 
    receivedByWarehouse(_LocalProductCode)
    
    {
      products[_LocalProductCode].ProductState = State.ProcessedByDistributor;
      emit ProcessedByDistributor(_LocalProductCode);
    }

    function packageProductByDistributor(uint _LocalProductCode) public payable 
    onlyDistributor() 
    processedByDistributor(_LocalProductCode)
    
    {
      products[_LocalProductCode].ProductState = State.PackageByDistributor;
      emit PackageByDistributor(_LocalProductCode);
    }

    function sellProductByDistributor(uint _LocalProductCode) public payable 
    onlyDistributor() 
    packageByDistributor(_LocalProductCode)
    
    {
      products[_LocalProductCode].ProductState = State.ForSaleByDistributor;
      emit ForSaleByDistributor(_LocalProductCode);
    }

    function purchaseProductByRetailer(uint _LocalProductCode) public payable 
    onlyRetailer() 
    forSaleByDistributor(_LocalProductCode){
      products[_LocalProductCode].ownerID = msg.sender;
      products[_LocalProductCode].RetailerID = msg.sender;
      products[_LocalProductCode].ProductState = State.PurchasedByRetailer;
      ProductsHistory[_LocalProductCode].blockDistributorToRetailer = block.number;
      emit PurchasedByRetailer(_LocalProductCode);
    }

    function shippedProductByDistributor(uint _LocalProductCode) public payable 
    onlyDistributor() 
    purchasedByRetailer(_LocalProductCode)
    
    {
      products[_LocalProductCode].ProductState = State.ShippedByDistributor;
      emit ShippedByDistributor(_LocalProductCode);
    }

    function shippedProductFromWarhouse(uint _LocalProductCode) public payable 
    onlyWarehouse() 
    shippedByDistributor(_LocalProductCode)
    
    {
      products[_LocalProductCode].ProductState = State.ShippedFromWarehouse;
      emit ShippedFromWarehouse(_LocalProductCode);
    }

    function receivedProductByRetailer(uint _LocalProductCode) public payable 
    onlyRetailer() 
    shippedFromWarehouse(_LocalProductCode)
    
    {
        products[_LocalProductCode].ownerID = msg.sender;
        products[_LocalProductCode].RetailerID = msg.sender;
        products[_LocalProductCode].ProductState = State.ReceivedByRetailer;
        ProductsHistory[_LocalProductCode].blockWarehouseToRetailer = block.number; 
        emit ReceivedByRetailer(_LocalProductCode);
    }

    function sellProductByRetailer(uint _LocalProductCode) public payable 
    onlyRetailer() 
    receivedByRetailer(_LocalProductCode)
    
    {
      products[_LocalProductCode].ProductState = State.ForSaleByRetailer;
      emit ForSaleByRetailer(_LocalProductCode);
    }

    function purchaseProductByConsumer(uint _LocalProductCode) public payable 
    onlyConsumer() 
    forSaleByRetailer(_LocalProductCode){
      products[_LocalProductCode].ownerID = msg.sender;
      products[_LocalProductCode].ConsumerID = msg.sender;
      products[_LocalProductCode].ProductState = State.PurchasedByConsumer;
      ProductsHistory[_LocalProductCode].blockRetailerToConsumer = block.number;
      emit PurchasedByConsumer(_LocalProductCode);
    }

}