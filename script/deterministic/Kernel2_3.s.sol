pragma solidity ^0.8.0;

import "./DeterministicDeploy.s.sol";

library Kernel_2_3_Deploy {
    address constant EXPECTED_KERNEL_2_3_ADDRESS = 0xD3F582F6B4814E989Ee8E96bc3175320B5A540ab;
    bytes constant KERNEL_2_3_CODE =
        hex"000000000000000000000000000000000000000000000000000000000000000061014034620001be57601f6200238b38819003918201601f19168301916001600160401b03831184841017620001c357808492602094604052833981010312620001be57516001600160a01b0381168103620001be57306080524660a05260a062000069620001d9565b600681526005602082016512d95c9b995b60d21b815260206200008b620001d9565b838152019264302e322e3360d81b845251902091208160c0528060e052604051917f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f83526020830152604082015246606082015230608082015220906101009182526101209081527f439ffe7df606b78489639bc0b827913bd09e1246fa6802968a5b3694c53e0dd96a010000000000000000000080600160f01b0319825416179055604051906121919283620001fa843960805183611b42015260a05183611b65015260c05183611bd7015260e05183611bfd01525182611b21015251818181610506015281816107c5015281816108d201528181610a5d01528181610b8501528181610d7f01528181610de901528181610f4d0152818161104c015281816111760152818161121f01526115660152f35b600080fd5b634e487b7160e01b600052604160045260246000fd5b60408051919082016001600160401b03811183821017620001c35760405256fe6080604052600436101561001d575b366111595761001b612047565b005b60003560e01c806306fdde031461019d5780630b3dc35414610198578063150b7a02146101935780631626ba7e1461018e57806329f8b17414610189578063333daf921461018457806334fcd5be1461017f5780633659cfe61461017a5780633a871cdd146101755780633e1b08121461017057806351166ba01461016b578063519454471461016657806354fd4d501461016157806355b14f501461015c57806357b750471461015757806384b0196e1461015257806388e7fd061461014d578063b0d691fe14610148578063b68df16d14610143578063bc197c811461013e578063d087d28814610139578063d1f5789414610134578063d54162211461012f5763f23a6e610361000e576110c7565b611035565b610f99565b610f1a565b610e8b565b610dae565b610d69565b610d34565b610c8c565b610c55565b610b6f565b610b1b565b610a16565b61094d565b610889565b610847565b6107a1565b6106be565b610639565b610491565b61043e565b6103b1565b610332565b6102fe565b60009103126101ad57565b600080fd5b634e487b7160e01b600052604160045260246000fd5b6001600160401b0381116101db57604052565b6101b2565b606081019081106001600160401b038211176101db57604052565b608081019081106001600160401b038211176101db57604052565b604081019081106001600160401b038211176101db57604052565b60c081019081106001600160401b038211176101db57604052565b90601f801991011681019081106001600160401b038211176101db57604052565b6040519061027a826101fb565b565b6040519061016082018281106001600160401b038211176101db57604052565b604051906102a982610216565b600682526512d95c9b995b60d21b6020830152565b919082519283825260005b8481106102ea575050826000602080949584010152601f8019910116010190565b6020818301810151848301820152016102c9565b346101ad5760003660031901126101ad5761032e61031a61029c565b6040519182916020835260208301906102be565b0390f35b346101ad5760003660031901126101ad5760206000805160206121718339815191525460501c6040519060018060a01b03168152f35b6001600160a01b038116036101ad57565b359061027a82610368565b9181601f840112156101ad578235916001600160401b0383116101ad57602083818601950101116101ad57565b346101ad5760803660031901126101ad576103cd600435610368565b6103d8602435610368565b6064356001600160401b0381116101ad576103f7903690600401610384565b5050604051630a85bd0160e11b8152602090f35b9060406003198301126101ad5760043591602435906001600160401b0382116101ad5761043a91600401610384565b9091565b346101ad5760206104576104513661040b565b91611c33565b6040516001600160e01b03199091168152f35b600435906001600160e01b0319821682036101ad57565b65ffffffffffff8116036101ad57565b60c03660031901126101ad576104a561046a565b602435906104b282610368565b604435906104bf82610368565b6064356104cb81610481565b608435936104d885610481565b60a4356001600160401b0381116101ad576104f7903690600401610384565b9590946001600160a01b0393337f0000000000000000000000000000000000000000000000000000000000000000861614158061062f575b61061d5784926105646105909261055561054761026d565b65ffffffffffff9094168452565b65ffffffffffff166020830152565b6001600160a01b03851660408201526001600160a01b038316606082015261058b87611121565b611803565b1693843b156101ad576040519063064acaab60e11b825281806105ba6000998a94600484016118b6565b038183895af18015610618576105ff575b5016906001600160e01b0319167fed03d2572564284398470d3f266a693e29ddfff3eba45fc06c5e91013d3213538480a480f35b8061060c610612926101c8565b806101a2565b386105cb565b61154d565b604051637046c88d60e01b8152600490fd5b503033141561052f565b346101ad57602061065261064c3661040b565b91611f8c565b604051908152f35b9291926001600160401b0382116101db5760405191610683601f8201601f19166020018461024c565b8294818452818301116101ad578281602093846000960137010152565b9080601f830112156101ad578160206106bb9335910161065a565b90565b6020806003193601126101ad576001600160401b036004358181116101ad57366023820112156101ad578060040135918083116101db578260051b9060409081519461070c8785018761024c565b85528585019160248094860101943686116101ad57848101935b8685106107365761001b8861121c565b84358481116101ad578201606060231982360301126101ad5783519161075b836101e0565b8782013561076881610368565b835260448201358b8401526064820135928684116101ad576107928c94938a8695369201016106a0565b86820152815201940193610726565b60203660031901126101ad576004356107b981610368565b6001600160a01b0390337f0000000000000000000000000000000000000000000000000000000000000000831614158061083d575b61061d57807f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc55167fbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b600080a2005b50303314156107ee565b6003196060368201126101ad57600435906001600160401b0382116101ad576101609082360301126101ad576106526020916044359060243590600401611559565b346101ad5760203660031901126101ad576004356001600160c01b038116908190036101ad57604051631aab3f0d60e11b815230600482015260248101919091526020816044817f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03165afa80156106185761032e9160009161091f575b506040519081529081906020820190565b610940915060203d8111610946575b610938818361024c565b81019061146e565b3861090e565b503d61092e565b346101ad5760203660031901126101ad5761032e61099261096c61046a565b6000606060405161097c816101fb565b8281528260208201528260408201520152611121565b6040519061099f826101fb565b805465ffffffffffff80821684528160301c16602084015260601c60408301526001808060a01b03910154166060820152604051918291829190916060608082019365ffffffffffff80825116845260208201511660208401528160018060a01b0391826040820151166040860152015116910152565b60803660031901126101ad57600435610a2e81610368565b6044356001600160401b0381116101ad57610a4d9036906004016106a0565b9060643560028110156101ad57337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b0316141580610af0575b80610adb575b61061d57610aa0816111d2565b610ac9576000828193926020839451920190602435905af13d82803e15610ac5573d90f35b3d90fd5b6040516367ce775960e01b8152600490fd5b50610aeb610ae7611d8c565b1590565b610a93565b5030331415610a8d565b60405190610b0782610216565b6005825264302e322e3360d81b6020830152565b346101ad5760003660031901126101ad5761032e61031a610afa565b9060406003198301126101ad57600435610b5081610368565b91602435906001600160401b0382116101ad5761043a91600401610384565b610b7836610b37565b90916001600160a01b03337f00000000000000000000000000000000000000000000000000000000000000008216141580610c4b575b61061d57806000805160206121718339815191525460501c1691610bd181612078565b1692836040519360009586947fa35f5cdc5fbabb614b4cd5064ce5543f43dc8fab0e4da41255230eb8aba2531c8680a3813b15610c47578385610c25819593829463064acaab60e11b8452600484016118b6565b03925af1801561061857610c37575080f35b8061060c610c44926101c8565b80f35b8380fd5b5030331415610bae565b346101ad5760003660031901126101ad5760206000805160206121718339815191525460e01b6040519063ffffffff60e01b168152f35b346101ad5760003660031901126101ad57610ce2610ca861029c565b610cb0610afa565b90604051928392600f60f81b8452610cd460209360e08587015260e08601906102be565b9084820360408601526102be565b90466060840152306080840152600060a084015282820360c08401528060605192838152019160809160005b828110610d1d57505050500390f35b835185528695509381019392810192600101610d0e565b346101ad5760003660031901126101ad5760206000805160206121718339815191525465ffffffffffff60405191831c168152f35b346101ad5760003660031901126101ad576040517f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03168152602090f35b60403660031901126101ad57600435610dc681610368565b6024356001600160401b0381116101ad57610de59036906004016106a0565b90337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b0316141580610e51575b80610e40575b61061d5760008281939260208394519201905af43d82803e15610ac5573d90f35b50610e4c610ae7611d8c565b610e1f565b5030331415610e19565b9181601f840112156101ad578235916001600160401b0383116101ad576020808501948460051b0101116101ad57565b346101ad5760a03660031901126101ad57610ea7600435610368565b610eb2602435610368565b6001600160401b036044358181116101ad57610ed2903690600401610e5b565b50506064358181116101ad57610eec903690600401610e5b565b50506084359081116101ad57610f06903690600401610384565b505060405163bc197c8160e01b8152602090f35b346101ad5760003660031901126101ad57604051631aab3f0d60e11b8152306004820152600060248201526020816044817f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03165afa80156106185761032e9160009161091f57506040519081529081906020820190565b610fa236610b37565b60008051602061217183398151915254919290916001600160a01b03919060501c821661102457610fd281612078565b1691823b156101ad57611007926000928360405180968195829463064acaab60e11b8452602060048501526024840191611895565b03925af180156106185761101757005b8061060c61001b926101c8565b60405162dc149f60e41b8152600490fd5b60203660031901126101ad5761104961046a565b337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03161415806110bd575b61061d5760008051602061217183398151915290815469ffffffffffff000000004260201b169160e01c9069ffffffffffffffffffff191617179055600080f35b503033141561107c565b346101ad5760a03660031901126101ad576110e3600435610368565b6110ee602435610368565b6084356001600160401b0381116101ad5761110d903690600401610384565b505060405163f23a6e6160e01b8152602090f35b63ffffffff60e01b166000527f439ffe7df606b78489639bc0b827913bd09e1246fa6802968a5b3694c53e0dda602052604060002090565b600061116f81356001600160e01b031916611121565b5460601c337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03161415806111c3575b61061d57818091368280378136915af43d82803e15610ac5573d90f35b506111cc611d8c565b156111a6565b600211156111dc57565b634e487b7160e01b600052602160045260246000fd5b80518210156112065760209160051b010190565b634e487b7160e01b600052603260045260246000fd5b337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03161415806112a9575b61061d5780519060005b82811061126557505050565b60008061127283856111f2565b5180516001600160a01b03166020916040838201519101519283519301915af13d6000803e156112a457600101611259565b3d6000fd5b506112b5610ae7611d8c565b61124f565b906004116101ad5790600490565b90929192836004116101ad5783116101ad57600401916003190190565b906024116101ad5760100190601490565b906058116101ad5760380190602090565b906024116101ad5760040190602090565b906038116101ad5760240190601490565b90600a116101ad5760040190600690565b906010116101ad57600a0190600690565b909392938483116101ad5784116101ad578101920390565b6001600160e01b0319903581811693926004811061138057505050565b60040360031b82901b16169150565b9190610160838203126101ad576113a461027c565b926113ae81610379565b8452602081013560208501526040810135916001600160401b03928381116101ad57816113dc9184016106a0565b604086015260608201358381116101ad57816113f99184016106a0565b60608601526080820135608086015260a082013560a086015260c082013560c086015260e082013560e08601526101008083013590860152610120808301358481116101ad578261144b9185016106a0565b9086015261014092838301359081116101ad5761146892016106a0565b90830152565b908160209103126101ad575190565b606080825282516001600160a01b031690820152919392916040916115439060208101516080840152838101516114c2610160918260a08701526101c08601906102be565b906115306114e2606085015193605f1994858983030160c08a01526102be565b608085015160e088015260a085015192610100938489015260c08601519061012091828a015260e08701519461014095868b01528701519089015285015184888303016101808901526102be565b92015190848303016101a08501526102be565b9460208201520152565b6040513d6000823e3d90fd5b6001600160a01b039392917f000000000000000000000000000000000000000000000000000000000000000085163303611777576004948535928361014481013501918760248401930135946115b86115b287866112ba565b90611363565b926001600160e01b0319808516918215611754576115d790369061138f565b946115f16000805160206121718339815191525460e01b90565b1616156116095760405163fc2f51c560e01b81528a90fd5b97989697600160e01b8103611703575090602095966116936116616116486116436115b287606460009901350160248782013591016112ba565b611121565b6001810154909a9081906001600160a01b0316986112c8565b995460d081901b6001600160d01b03191660709190911b65ffffffffffff60a01b1617995b8b6116f5575b369161065a565b6101408501526116b7604051998a9788968794633a871cdd60e01b8652850161147d565b0393165af1908115610618576106bb926000926116d5575b506120ee565b6116ee91925060203d811161094657610938818361024c565b90386116cf565b348080808f335af15061168c565b9095939190600160e11b036117475761173d611693946000936117386115b28a606460209c01350160248d82013591016112ba565b6118c7565b9199929691611686565b5050505050505050600190565b9697505050505050506106bb9394508215611ec0573434343486335af150611ec0565b604051636b31ba1560e11b8152600490fd5b6bffffffffffffffffffffffff1990358181169392601481106117ab57505050565b60140360031b82901b16169150565b3590602081106117c8575090565b6000199060200360031b1b1690565b6001600160d01b031990358181169392600681106117f457505050565b60060360031b82901b16169150565b81516020830151604084015160309190911b6bffffffffffff0000000000001665ffffffffffff9290921691909117606091821b6bffffffffffffffffffffffff19161782559091015160019190910180546001600160a01b0319166001600160a01b0392909216919091179055565b90602091808252806000848401376000828201840152601f01601f1916010190565b908060209392818452848401376000828201840152601f01601f1916010190565b9160206106bb938181520191611895565b91906118d382826112e5565b6118dc91611789565b60601c936118ea83836112f6565b6118f3916117ba565b60588301607882019485836058019061190d91838861134b565b611916916117ba565b6119208287611307565b611929916117ba565b6119338388611318565b61193c91611789565b60601c61194a36878761065a565b8051602091820120604080517f3ce406685c1b3551d706d85a68afdaa49ac4e07b451ad9b8ff8b58c3ee9641769381019384526001600160e01b03198e169181019190915260608101949094526001600160a01b0392909216608084015260a080840192909252908252906119c060c08261024c565b5190206119cc90611b1f565b90840196607888016119df91848961134b565b906119e992611f8c565b6119f38287611307565b6001600160a01b031991611a0791906117ba565b16611a11916120ee565b966078868801019682036077190195611a2a8382611329565b611a33916117d7565b60d01c92611a41818361133a565b611a4a916117d7565b60d01c91611a588282611318565b611a6191611789565b60601c91611a6e916112e5565b611a7791611789565b60601c91611a8361026d565b65ffffffffffff909516855265ffffffffffff1660208501526001600160a01b031660408401526001600160a01b03166060830152611ac190611121565b90611acb91611803565b6001600160a01b03871691823b156101ad57611b01926000928360405180968195829463064acaab60e11b8452600484016118b6565b03925af1801561061857611b125750565b8061060c61027a926101c8565b7f00000000000000000000000000000000000000000000000000000000000000007f000000000000000000000000000000000000000000000000000000000000000030147f000000000000000000000000000000000000000000000000000000000000000046141615611bac575b671901000000000000600052601a52603a526042601820906000603a52565b5060a06040517f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f81527f000000000000000000000000000000000000000000000000000000000000000060208201527f0000000000000000000000000000000000000000000000000000000000000000604082015246606082015230608082015220611b8d565b91611cf291611cf793611cdc611cea611c4a61029c565b611c52610afa565b906020815191012090602081519101206040519060208201927f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f8452604083015260608201524660808201523060a082015260a08152611cb181610231565b51902092604051928391602083019586909160429261190160f01b8352600283015260228201520190565b03601f19810183528261024c565b519020611f8c565b6120c5565b9065ffffffffffff928342911611159283611d44575b505081611d32575b5015611d2657630b135d3f60e11b90565b6001600160e01b031990565b6001600160a01b031615905038611d15565b429116101591503880611d0d565b908160209103126101ad575180151581036101ad5790565b6001600160a01b0390911681526040602082018190526106bb92910190611873565b611d963633611ff4565b611ebb57611daf6000356001600160e01b031916611121565b6001810154611dce906001600160a01b03165b6001600160a01b031690565b906001600160a01b03821615908115611e7f575b8115611e54575b5015611df55750600090565b60206040518092639ea9bd5960e01b82528180611e16363360048401611d6a565b03915afa90811561061857600091611e2c575090565b6106bb915060203d8111611e4d575b611e45818361024c565b810190611d52565b503d611e3b565b54611e6e915065ffffffffffff165b65ffffffffffff1690565b65ffffffffffff4291161138611de9565b905065ffffffffffff611e9f611e63835465ffffffffffff9060301c1690565b168015159081611eb1575b5090611de2565b9050421138611eaa565b600190565b9091611ecc368361138f565b610140928381013590601e19813603018212156101ad5701938435946001600160401b0386116101ad576020019385360385136101ad57611f1661168c87611f5e986020986112c8565b908301526000611f40611dc26000805160206121718339815191525460501c60018060a01b031690565b9260405196879586948593633a871cdd60e01b85526004850161147d565b03925af190811561061857600091611f74575090565b6106bb915060203d811161094657610938818361024c565b600080516020612171833981519152546040805163199ed7c960e11b8152600481019390935260248301529092602092849260501c6001600160a01b03169183918291611fde91604484019190611895565b03915afa90811561061857600091611f74575090565b6000805160206121718339815191525460408051639ea9bd5960e01b81526001600160a01b039384166004820152602481019190915292602092849260501c169082908190611e16906044830190611873565b7f88a5966d370b9919b20f3e2c13ff65706f196a4e32cc2c12bf57088f8852587460408051338152346020820152a1565b60008051602061217183398151915280547fffff0000000000000000000000000000000000000000ffffffffffffffffffff1660509290921b600160501b600160f01b0316919091179055565b8065ffffffffffff91828160a01c169283156001146120e6575b5060d01c92565b9250386120df565b8082186001600160a01b031615600114612109575050600190565b65ffffffffffff60a01b8181169265ffffffffffff60a01b1992831692811691908415612167575b81168015612160575b848110908518028085189414612158575b5081811190821802181790565b92503861214b565b508061213a565b9350809361213156fe439ffe7df606b78489639bc0b827913bd09e1246fa6802968a5b3694c53e0dd90000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d2789";

    address constant EXPECTED_KERNEL_LITE_2_3_ADDRESS = 0x482EC42E88a781485E1B6A4f07a0C5479d183291;
    bytes constant KERNEL_LITE_2_3_CODE =
        hex"0000000000000000000000000000000000000000000000000000000000000000610160346200021a57601f620024b438819003918201601f19168301916001600160401b038311848410176200021f5780849260409485528339810103126200021a5780516001600160a01b039182821682036200021a57602001519182168092036200021a57306080524660a05260a06200007a62000235565b600681526005602082016512d95c9b995b60d21b815260206200009c62000235565b838152019264302e322e3360d81b845251902091208160c0528060e052604051917f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f83526020830152604082015246606082015230608082015220916101009283526101209182527f439ffe7df606b78489639bc0b827913bd09e1246fa6802968a5b3694c53e0dd96a010000000000000000000080600160f01b03198254161790556101409081527fdea7fea882fba743201b2aeb1babf326b8944488db560784858525d123ee7e976001808060a01b03198254161790556040519161225e938462000256853960805184611c54015260a05184611c77015260c05184611ce9015260e05184611d0f01525183611c33015251828181610526015281816107e5015281816108f201528181610a7d01528181610b9e01528181610d3d01528181610da701528181610f50015281816110f4015281816111ec0152818161129c01528181611345015261169a015251818181610eee0152610fb10152f35b600080fd5b634e487b7160e01b600052604160045260246000fd5b60408051919082016001600160401b038111838210176200021f5760405256fe6080604052600436101561001d575b3661127f5761001b611fe4565b005b60003560e01c806306fdde03146101bd5780630b3dc354146101b8578063150b7a02146101b35780631626ba7e146101ae57806329f8b174146101a9578063333daf92146101a457806334fcd5be1461019f5780633659cfe61461019a5780633a871cdd146101955780633e1b08121461019057806351166ba01461018b578063519454471461018657806354fd4d501461018157806355b14f501461017c57806357b750471461017757806384b0196e1461017257806388e7fd061461016d578063b0d691fe14610168578063b68df16d14610163578063bc197c811461015e578063cdaea3ed14610159578063d087d28814610154578063d1f578941461014f578063d54162211461014a578063f23a6e61146101455763f2fde38b0361000e576111c9565b61116f565b6110dd565b610f9c565b610f1d565b610ed8565b610e49565b610d6c565b610d27565b610cf2565b610c4a565b610c13565b610b8f565b610b3b565b610a36565b61096d565b6108a9565b610867565b6107c1565b6106de565b610659565b6104b1565b61045e565b6103d1565b610352565b61031e565b60009103126101cd57565b600080fd5b634e487b7160e01b600052604160045260246000fd5b6001600160401b0381116101fb57604052565b6101d2565b606081019081106001600160401b038211176101fb57604052565b608081019081106001600160401b038211176101fb57604052565b604081019081106001600160401b038211176101fb57604052565b60c081019081106001600160401b038211176101fb57604052565b90601f801991011681019081106001600160401b038211176101fb57604052565b6040519061029a8261021b565b565b6040519061016082018281106001600160401b038211176101fb57604052565b604051906102c982610236565b600682526512d95c9b995b60d21b6020830152565b919082519283825260005b84811061030a575050826000602080949584010152601f8019910116010190565b6020818301810151848301820152016102e9565b346101cd5760003660031901126101cd5761034e61033a6102bc565b6040519182916020835260208301906102de565b0390f35b346101cd5760003660031901126101cd57602060008051602061221e8339815191525460501c6040519060018060a01b03168152f35b6001600160a01b038116036101cd57565b359061029a82610388565b9181601f840112156101cd578235916001600160401b0383116101cd57602083818601950101116101cd57565b346101cd5760803660031901126101cd576103ed600435610388565b6103f8602435610388565b6064356001600160401b0381116101cd576104179036906004016103a4565b5050604051630a85bd0160e11b8152602090f35b9060406003198301126101cd5760043591602435906001600160401b0382116101cd5761045a916004016103a4565b9091565b346101cd5760206104776104713661042b565b91611d45565b6040516001600160e01b03199091168152f35b600435906001600160e01b0319821682036101cd57565b65ffffffffffff8116036101cd57565b60c03660031901126101cd576104c561048a565b602435906104d282610388565b604435906104df82610388565b6064356104eb816104a1565b608435936104f8856104a1565b60a4356001600160401b0381116101cd576105179036906004016103a4565b9590946001600160a01b0393337f0000000000000000000000000000000000000000000000000000000000000000861614158061064f575b61063d5784926105846105b09261057561056761028d565b65ffffffffffff9094168452565b65ffffffffffff166020830152565b6001600160a01b03851660408201526001600160a01b03831660608201526105ab87611247565b611941565b1693843b156101cd576040519063064acaab60e11b825281806105da6000998a94600484016119b1565b038183895af180156106385761061f575b5016906001600160e01b0319167fed03d2572564284398470d3f266a693e29ddfff3eba45fc06c5e91013d3213538480a480f35b8061062c610632926101e8565b806101c2565b386105eb565b611681565b604051637046c88d60e01b8152600490fd5b503033141561054f565b346101cd57602061067261066c3661042b565b91612136565b604051908152f35b9291926001600160401b0382116101fb57604051916106a3601f8201601f19166020018461026c565b8294818452818301116101cd578281602093846000960137010152565b9080601f830112156101cd578160206106db9335910161067a565b90565b6020806003193601126101cd576001600160401b036004358181116101cd57366023820112156101cd578060040135918083116101fb578260051b9060409081519461072c8785018761026c565b85528585019160248094860101943686116101cd57848101935b8685106107565761001b88611342565b84358481116101cd578201606060231982360301126101cd5783519161077b83610200565b8782013561078881610388565b835260448201358b8401526064820135928684116101cd576107b28c94938a8695369201016106c0565b86820152815201940193610746565b60203660031901126101cd576004356107d981610388565b6001600160a01b0390337f0000000000000000000000000000000000000000000000000000000000000000831614158061085d575b61063d57807f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc55167fbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b600080a2005b503033141561080e565b6003196060368201126101cd57600435906001600160401b0382116101cd576101609082360301126101cd57610672602091604435906024359060040161168d565b346101cd5760203660031901126101cd576004356001600160c01b038116908190036101cd57604051631aab3f0d60e11b815230600482015260248101919091526020816044817f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03165afa80156106385761034e9160009161093f575b506040519081529081906020820190565b610960915060203d8111610966575b610958818361026c565b8101906115a2565b3861092e565b503d61094e565b346101cd5760203660031901126101cd5761034e6109b261098c61048a565b6000606060405161099c8161021b565b8281528260208201528260408201520152611247565b604051906109bf8261021b565b805465ffffffffffff80821684528160301c16602084015260601c60408301526001808060a01b03910154166060820152604051918291829190916060608082019365ffffffffffff80825116845260208201511660208401528160018060a01b0391826040820151166040860152015116910152565b60803660031901126101cd57600435610a4e81610388565b6044356001600160401b0381116101cd57610a6d9036906004016106c0565b9060643560028110156101cd57337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b0316141580610b10575b80610afb575b61063d57610ac0816112f8565b610ae9576000828193926020839451920190602435905af13d82803e15610ae5573d90f35b3d90fd5b6040516367ce775960e01b8152600490fd5b50610b0b610b07611eb5565b1590565b610ab3565b5030331415610aad565b60405190610b2782610236565b6005825264302e322e3360d81b6020830152565b346101cd5760003660031901126101cd5761034e61033a610b1a565b9060406003198301126101cd57600435610b7081610388565b91602435906001600160401b0382116101cd5761045a916004016103a4565b610b9836610b57565b505050337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b0316141580610c09575b61063d5760405162461bcd60e51b815260206004820152600f60248201526e1b9bdd081a5b5c1b195b595b9d1959608a1b6044820152606490fd5b5030331415610bce565b346101cd5760003660031901126101cd57602060008051602061221e8339815191525460e01b6040519063ffffffff60e01b168152f35b346101cd5760003660031901126101cd57610ca0610c666102bc565b610c6e610b1a565b90604051928392600f60f81b8452610c9260209360e08587015260e08601906102de565b9084820360408601526102de565b90466060840152306080840152600060a084015282820360c08401528060605192838152019160809160005b828110610cdb57505050500390f35b835185528695509381019392810192600101610ccc565b346101cd5760003660031901126101cd57602060008051602061221e8339815191525465ffffffffffff60405191831c168152f35b346101cd5760003660031901126101cd576040517f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03168152602090f35b60403660031901126101cd57600435610d8481610388565b6024356001600160401b0381116101cd57610da39036906004016106c0565b90337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b0316141580610e0f575b80610dfe575b61063d5760008281939260208394519201905af43d82803e15610ae5573d90f35b50610e0a610b07611eb5565b610ddd565b5030331415610dd7565b9181601f840112156101cd578235916001600160401b0383116101cd576020808501948460051b0101116101cd57565b346101cd5760a03660031901126101cd57610e65600435610388565b610e70602435610388565b6001600160401b036044358181116101cd57610e90903690600401610e19565b50506064358181116101cd57610eaa903690600401610e19565b50506084359081116101cd57610ec49036906004016103a4565b505060405163bc197c8160e01b8152602090f35b346101cd5760003660031901126101cd576040517f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03168152602090f35b346101cd5760003660031901126101cd57604051631aab3f0d60e11b8152306004820152600060248201526020816044817f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03165afa80156106385761034e9160009161093f57506040519081529081906020820190565b610fa536610b57565b916001600160a01b03907f000000000000000000000000000000000000000000000000000000000000000082169082160361108d5760008051602061223e833981519152541661103c5761100861100261001b9361100e936113e0565b906118c7565b60601c90565b60008051602061223e83398151915280546001600160a01b0319166001600160a01b03909216919091179055565b60405162461bcd60e51b8152602060048201526024808201527f4b65726e656c4c69746545434453413a20616c726561647920696e697469616c6044820152631a5e995960e21b6064820152608490fd5b60405162461bcd60e51b815260206004820152602260248201527f4b65726e656c4c69746545434453413a20696e76616c69642076616c6964617460448201526137b960f11b6064820152608490fd5b60203660031901126101cd576110f161048a565b337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b0316141580611165575b61063d5760008051602061221e83398151915290815469ffffffffffff000000004260201b169160e01c9069ffffffffffffffffffff191617179055600080f35b5030331415611124565b346101cd5760a03660031901126101cd5761118b600435610388565b611196602435610388565b6084356001600160401b0381116101cd576111b59036906004016103a4565b505060405163f23a6e6160e01b8152602090f35b60203660031901126101cd576004356111e181610388565b6001600160a01b03337f0000000000000000000000000000000000000000000000000000000000000000821614158061123d575b61063d5760008051602061223e83398151915280546001600160a01b03191691909216179055005b5030331415611215565b63ffffffff60e01b166000527f439ffe7df606b78489639bc0b827913bd09e1246fa6802968a5b3694c53e0dda602052604060002090565b600061129581356001600160e01b031916611247565b5460601c337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03161415806112e9575b61063d57818091368280378136915af43d82803e15610ae5573d90f35b506112f2611eb5565b156112cc565b6002111561130257565b634e487b7160e01b600052602160045260246000fd5b805182101561132c5760209160051b010190565b634e487b7160e01b600052603260045260246000fd5b337f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03161415806113cf575b61063d5780519060005b82811061138b57505050565b6000806113988385611318565b5180516001600160a01b03166020916040838201519101519283519301915af13d6000803e156113ca5760010161137f565b3d6000fd5b506113db610b07611eb5565b611375565b906014116101cd5790601490565b906004116101cd5790600490565b90929192836004116101cd5783116101cd57600401916003190190565b906024116101cd5760100190601490565b906058116101cd5760380190602090565b906024116101cd5760040190602090565b906038116101cd5760240190601490565b90600a116101cd5760040190600690565b906010116101cd57600a0190600690565b909392938483116101cd5784116101cd578101920390565b6001600160e01b031990358181169392600481106114b457505050565b60040360031b82901b16169150565b9190610160838203126101cd576114d861029c565b926114e281610399565b8452602081013560208501526040810135916001600160401b03928381116101cd57816115109184016106c0565b604086015260608201358381116101cd578161152d9184016106c0565b60608601526080820135608086015260a082013560a086015260c082013560c086015260e082013560e08601526101008083013590860152610120808301358481116101cd578261157f9185016106c0565b9086015261014092838301359081116101cd5761159c92016106c0565b90830152565b908160209103126101cd575190565b606080825282516001600160a01b031690820152919392916040916116779060208101516080840152838101516115f6610160918260a08701526101c08601906102de565b90611664611616606085015193605f1994858983030160c08a01526102de565b608085015160e088015260a085015192610100938489015260c08601519061012091828a015260e08701519461014095868b01528701519089015285015184888303016101808901526102de565b92015190848303016101a08501526102de565b9460208201520152565b6040513d6000823e3d90fd5b6001600160a01b039392917f0000000000000000000000000000000000000000000000000000000000000000851633036118b5576004948535928361014481013501918760248401930135946116ec6116e687866113ee565b90611497565b926001600160e01b03198085169182156118885761170b9036906114c3565b9461172560008051602061221e8339815191525460e01b90565b16161561173d5760405163fc2f51c560e01b81528a90fd5b97989697600160e01b8103611837575090602095966117c761179561177c6117776116e687606460009901350160248782013591016113ee565b611247565b6001810154909a9081906001600160a01b0316986113fc565b995460d081901b6001600160d01b03191660709190911b65ffffffffffff60a01b1617995b8b611829575b369161067a565b6101408501526117eb604051998a9788968794633a871cdd60e01b865285016115b1565b0393165af1908115610638576106db92600092611809575b5061219b565b61182291925060203d811161096657610958818361026c565b9038611803565b348080808f335af1506117c0565b9095939190600160e11b0361187b576118716117c79460009361186c6116e68a606460209c01350160248d82013591016113ee565b6119d9565b91999296916117ba565b5050505050505050600190565b9750505050505050916106db939450806118a3575b5061203e565b3490349034903490335af1503861189d565b604051636b31ba1560e11b8152600490fd5b6bffffffffffffffffffffffff1990358181169392601481106118e957505050565b60140360031b82901b16169150565b359060208110611906575090565b6000199060200360031b1b1690565b6001600160d01b0319903581811693926006811061193257505050565b60060360031b82901b16169150565b81516020830151604084015160309190911b6bffffffffffff0000000000001665ffffffffffff9290921691909117606091821b6bffffffffffffffffffffffff19161782559091015160019190910180546001600160a01b0319166001600160a01b0392909216919091179055565b90918060409360208452816020850152848401376000828201840152601f01601f1916010190565b91906119e58282611419565b6119ee916118c7565b60601c936119fc838361142a565b611a05916118f8565b605883016078820194858360580190611a1f91838861147f565b611a28916118f8565b611a32828761143b565b611a3b916118f8565b611a45838861144c565b611a4e916118c7565b60601c611a5c36878761067a565b8051602091820120604080517f3ce406685c1b3551d706d85a68afdaa49ac4e07b451ad9b8ff8b58c3ee9641769381019384526001600160e01b03198e169181019190915260608101949094526001600160a01b0392909216608084015260a08084019290925290825290611ad260c08261026c565b519020611ade90611c31565b9084019660788801611af191848961147f565b90611afb92612136565b611b05828761143b565b6001600160a01b031991611b1991906118f8565b16611b239161219b565b966078868801019682036077190195611b3c838261145d565b611b4591611915565b60d01c92611b53818361146e565b611b5c91611915565b60d01c91611b6a828261144c565b611b73916118c7565b60601c91611b8091611419565b611b89916118c7565b60601c91611b9561028d565b65ffffffffffff909516855265ffffffffffff1660208501526001600160a01b031660408401526001600160a01b03166060830152611bd390611247565b90611bdd91611941565b6001600160a01b03871691823b156101cd57611c13926000928360405180968195829463064acaab60e11b8452600484016119b1565b03925af1801561063857611c245750565b8061062c61029a926101e8565b7f00000000000000000000000000000000000000000000000000000000000000007f000000000000000000000000000000000000000000000000000000000000000030147f000000000000000000000000000000000000000000000000000000000000000046141615611cbe575b671901000000000000600052601a52603a526042601820906000603a52565b5060a06040517f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f81527f000000000000000000000000000000000000000000000000000000000000000060208201527f0000000000000000000000000000000000000000000000000000000000000000604082015246606082015230608082015220611c9f565b91611e0491611e0993611dee611dfc611d5c6102bc565b611d64610b1a565b906020815191012090602081519101206040519060208201927f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f8452604083015260608201524660808201523060a082015260a08152611dc381610251565b51902092604051928391602083019586909160429261190160f01b8352600283015260228201520190565b03601f19810183528261026c565b519020612136565b612015565b9065ffffffffffff928342911611159283611e56575b505081611e44575b5015611e3857630b135d3f60e11b90565b6001600160e01b031990565b6001600160a01b031615905038611e27565b429116101591503880611e1f565b908160209103126101cd575180151581036101cd5790565b6001600160a01b0390911681526040602082018190528101829052606091806000848401376000828201840152601f01601f1916010190565b60008051602061223e833981519152546001600160a01b039081163314611fde57611eeb6000356001600160e01b031916611247565b60018101546001600160a01b031691821615908115611fa2575b8115611f77575b5015611f185750600090565b60206040518092639ea9bd5960e01b82528180611f39363360048401611e7c565b03915afa90811561063857600091611f4f575090565b6106db915060203d8111611f70575b611f68818361026c565b810190611e64565b503d611f5e565b54611f91915065ffffffffffff165b65ffffffffffff1690565b65ffffffffffff4291161138611f0c565b905065ffffffffffff611fc2611f86835465ffffffffffff9060301c1690565b168015159081611fd4575b5090611f05565b9050421138611fcd565b50600190565b7f88a5966d370b9919b20f3e2c13ff65706f196a4e32cc2c12bf57088f8852587460408051338152346020820152a1565b8065ffffffffffff91828160a01c16928315600114612036575b5060d01c92565b92503861202f565b9061206e906020527b19457468657265756d205369676e6564204d6573736167653a0a3332600052603c60042090565b9061014081013590601e19813603018212156101cd5701908135916001600160401b0383116101cd576020019180360383136101cd576117c0816120b5926120bb956113fc565b906120e7565b60008051602061223e833981519152546001600160a01b039081169116036120e257600090565b600190565b6001608060006041602094969596604080519880519285526060810151851a88528781015182520151606052145afa51913d15612128576000606052604052565b638baa579f6000526004601cfd5b6020527b19457468657265756d205369676e6564204d6573736167653a0a3332600052603c60042061216f92916120b59192369161067a565b60008051602061223e833981519152546001600160a01b0391821691161461219657600190565b600090565b8082186001600160a01b0316156001146121b6575050600190565b65ffffffffffff60a01b8181169265ffffffffffff60a01b1992831692811691908415612214575b8116801561220d575b848110908518028085189414612205575b5081811190821802181790565b9250386121f8565b50806121e7565b935080936121de56fe439ffe7df606b78489639bc0b827913bd09e1246fa6802968a5b3694c53e0dd9dea7fea882fba743201b2aeb1babf326b8944488db560784858525d123ee7e970000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d2789000000000000000000000000d9ab5096a832b9ce79914329daee236f8eea0390";

    function deploy() internal returns (address, address) {
        DeterministicDeploy.checkDeploy("Kernel 2.3", EXPECTED_KERNEL_2_3_ADDRESS, KERNEL_2_3_CODE);
        DeterministicDeploy.checkDeploy(
            "Kernel Lite 2.3", EXPECTED_KERNEL_LITE_2_3_ADDRESS, KERNEL_LITE_2_3_CODE
        );
        return (EXPECTED_KERNEL_2_3_ADDRESS, EXPECTED_KERNEL_LITE_2_3_ADDRESS);
    }
}
