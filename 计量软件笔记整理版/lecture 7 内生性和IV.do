******************************lecture 11 内生性和IV******************************
"内生性:模型中一个或者多个解释变量与误差项间存在相关关系,解释变量不是外生的了"

"内生性的后果：有偏且不一致,不一致问题就大了,不一致会破坏样本推断总体,统计推断久失去了意义"

"内生性产生的原因:针对截面和面板数据的内生性,(1)遗漏变量;(2)样本自选择;(3)双向因果;(4)测量误差"

"解决内生性的办法:工具变量;面板数据;代理变量;联立方程(古老);DID;RD......"

"为什么面板数据可以用于消除内生性:不仅仅是因为数据量大"

 *-10.1 IV工具变量法
 * 作为工具变量的必要条件:(1)IV引入后不能和误差项相关;(2)IV要与引起内生性的变量相关
 *                             外生性                       相关性
 
  reg 经济增长 制度                                          //经济增长与制度双向因果
  第一步:找制度的代理变量,财产制度,作者认为制度中最根本的是财产制度,要论证一下吧
  第二步:从财产制度往下找-->殖民者对殖民地的喜爱程度-->殖民者登陆殖民地时的死亡率,找到能找到数据的
 
 *-10.2 工具变量分类
 (1)恰好识别:一个内生变量对应一个工具变量
 (2)过度识别:一个内生变量对应多个工具变量
 (3)无法识别:内生变量的个数多与可以找到的工具变量
 
 *-10.3 工具变量估计法
 * 两阶段最小二乘
 "大样本性质:一致性;渐进无偏;渐进正太"
 
 use "/Users/mac/Desktop/stata/mroz.dta", clear
  
 drop if inlf==0                                           //排除掉不工作的妇女
 reg lwage educ exper expersq, r
  
 //代理变量 IQ-->ability,被代理的变量可以没有数据所以采用代理变量
 //工具变量 被工具变量的的变量必须要有数据,才可以做第一阶段回归嘛

 use "/Users/mac/Desktop/stata/mroz.dta", clear
 "评价教育对于工资的影响,而教育程度和能力相关联,能力又在误差项中,于是会产生了内生性.那么寻找教育的工具变量来消除内生性"
 "通常孩子的受教育程度和父母的教育程度有关,那么用父母教育程度作为孩子教育程度的工具变量满足了相关性,不仅如此父母受教育程度肯定是外省的,也满足了外生性"
 
 reg lwage educ exper expersq                             //会出现内生性
 
 "第一阶段"
 reg educ mothedu fathedu exper expersq if inlf==1, r     //被工具变量的变量要与所有工具变量和剩下的其他解释变量做回归
 test (_b[mothedu]=0) (_b[fathedu]=0)                  //F值很大时工具变量选的就挺好,强工具变量当工具变量个数为1,2,3,4时,F临界值为8.96,11.59,12.83,22.88
 
 drop educIV
 predict educIV, xb
 
 "第二阶段"
 reg lwage educIV exper expersq if inlf==1, r
 
 * 把两个阶段分开写诗=时会出现误差,合成一步减小误差

 * 直接用命令一次性两阶段最小二乘
 ivregress 2sls lwage exper expersq (educ=mothedu fathedu) if inlf==1, r
 //括号里面是要被工具变量的,等号右边是用来做工具变量的变量

 ivregress 2sls lwage exper expersq (educ=mothedu) if inlf==1,  r first //first表示把合着的两阶段分为两个阶段

 *外生性检验(没法先做:是说在两阶段回归做完之前没法做)
 
 //对于过度识别的情况sargen检验可以一定程度上检验外生
 ivregress 2sls lwage exper expersq (educ=mothedu fathedu) if inlf==1,  r first
 estat overid                                               //不会报告sargen检验值
 
 ivregress 2sls lwage exper expersq (educ=mothedu fathedu) if inlf==1 //做sargen检验默认没有异方差,或者要消除异方差,这里不能加robust的选项,加了robust不会报告sargen检验值
 estat overid

 "如何在数据上检验究竟有没有内生性呢"
 "既然两阶段最小二乘之后是没有内生性的,那么如果原来没有内生性就应该回使得普通最小二乘的估计系数和两阶段最小二乘估计的差不多"
 * 那么可以根据beta们的差距来判断是否存在内生性
 * 没有内生性时IV估计与普通最小二乘是差不多的
 ivregress 2sls lwage exper expersq (educ= mothedu fathedu) if inlf==1, r
 estimates store iv2_r
 
 ivregress 2sls lwage exper expersq (educ= mothedu fathedu) if inlf==1
 estimates store iv2
 
 reg lwage educ exper expersq if inlf==1,r
 estimates store ols_r
 
 reg lwage educ exper expersq if inlf==1
 estimates store ols
 
 hausman iv2 ols, constant sigmamore                          //原假设是没有内生性
 //因为内生性问题是非常严重的这里p临界值选取10%,小于10%都拒绝原假设:没有内生性
 
 hausman iv2_r ols, constant sigmamore 
 hausman iv2 ols_r, constant sigmamore  
 hausman iv2_r ols_r, constant sigmamore                      //这三个都会报错
 "hausman cannot be used with vce(robust), vce(cluster cvar), or p-weighted data"

 ivregress 2sls lwage exper expersq (educ=mothedu fathedu) if inlf==1
 estat endogenous //这个也能做内生性检验,这个内生性检验是hausman检验





























