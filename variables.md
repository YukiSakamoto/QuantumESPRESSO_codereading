#  QEの重要な変数

### Modules/parameters.f90に定義されているもの

#### parameters

| name                      | type    | content                        |
| ------------------------- | ------- | ------------------------------ |
| ntypex(default:  10)      | integer | 異なる原子種の最大数           |
| npsx                      | integer | 異なる擬ポテンシャルの最大個数 |
| nsx                       | integer | 原子種の最大個数(CP)           |
| npk(default: 40000)       | integer | k点の最大個数                  |
| lmaxx(default:3)          | integer |                                |
| lqmax(default: 2*lmaxx+1) | integer |                                |

### pwcom.f90に定義されているもの

#### klist

| name                  | type                 | content                                                |
| --------------------- | -------------------- | ------------------------------------------------------ |
| smearing              | char(len=32)         | スメアリングタイプ                                     |
| xk(3,  npk)           | real(dp)             | k点の座標                                              |
| wk(npk)               | real(dp)             | k点の重み                                              |
| xqq(3)                | real(dp)             | q点の座標                                              |
| degauss               | real(dp)             | スメアリングパラメーター                               |
| nelec                 | real(dp)             | 電子数                                                 |
| neleup                | real(dp)             | アップスピンの電子数(two_fermi_energiesがTRUEの時)     |
| neldw                 | real(dp)             | ダウンスピンの電子数(two_fermi_energiesがTRUEの時)     |
| tot_magnetization     | real(dp)             | nelup - neldw                                          |
| tot_charge            | real(dp)             | 全チャージ                                             |
| qnorm                 | real(dp)             | \|q\|の値。Phonon+USPPの時のみ使う。                   |
| igk_k(:,:)            | integer, allocatable | 与えらえれたk+Gのインデックスに対応するGのインデックス |
| ngk(:)                | integer, allocatable | 各k点の平面波の数                                      |
| nks                   | integer              | プール内のk点の数                                      |
| nkstot                | integer              | 全てのk点の数                                          |
| ngauss                | integer              | スメアリング方法のtype                                 |
| lgauss                | logical              | trueならGaussian broadening                            |
| ltetra                | logical              | trueならテトラへドロン法                               |
| lxkcry(default:false) | logical              |                                                        |
| two_fermi_energies    | logical              | TRUEならnelup/neldw, ef_up/ef_dwを別々にセットする     |

#### lsda_mod

| name                           | type     | content                                       |
| ------------------------------ | -------- | --------------------------------------------- |
| lsda                           | logical  |                                               |
| magtot                         | real(dp) | 全磁化                                        |
| absmag                         | real(dp) | 全磁化の絶対値                                |
| starting_magnetization(ntypex) | real(dp) | 計算開始時の磁化                              |
| nspin                          | integer  | スピン分極の種類。2:lsda, 1: その他           |
| current_spin                   | integer  | 現在のk点のスピン                             |
| isk(npk)                       | integer  | k点毎のスピンの上下。1: spin up, 2: spin down |

#### vlocal

逆空間での局所ポテンシャルの定義に必要な変数

| name                   | type                     | content                        |
| ---------------------- | ------------------------ | ------------------------------ |
| strt(:,:)              | complex(dp), allocatable | 構造因子                       |
| vloc(:,:)              | real(dp), allocatable    | 各原子タイプの局所ポテンシャル |
| starting_charge(ntypx) | real(dp)                 | 計算開始の原子の電荷           |

#### wvfct

| name       | type                  | content                                                  |
| ---------- | --------------------- | -------------------------------------------------------- |
| npwx       | integer               | 波動関数の基底となるPWの最大数                           |
| nbndx      | integer               | 対角化の際のバンドの最大個数                             |
| npwx       | integer               | バンドの個数                                             |
| current_k  | integer               | 考慮中のk点のインデックス                                |
| et(:,:)    | real(dp), allocatable | ハミルトニアンの固有値                                   |
| wg(:,:)    | real(dp), allocatable | 各k点・バンドの重み                                      |
| g2kin(:)   | real(dp), allocatable | 運動エネルギー                                           |
| btype(:,:) | integer, allocatable  | 対応する状態が正確に収束している場合は1, そうでなければ0 |

#### ener

| name             | type     | content                             |
| ---------------- | -------- | ----------------------------------- |
| etot             | real(dp) | 固体中の全KSエネルギー              |
| hwf_energy       | real(dp) | Harris-Weinert-Foulkesエネルギー    |
| eband            | real(dp) | バンドのエネルギー                  |
| deband           | real(dp) | 変分エネルギーを得るためのSCFの補正 |
| ehart            | real(dp) | ハートリーエネルギー                |
| etxc             | real(dp) | 交換・相関エネルギー                |
| vtxc             | real(dp) | その他の交換・相関エネルギー        |
| etxcc            | real(dp) | nlcc交換・相関補正                  |
| ewld             | real(dp) | エワルドエネルギー                  |
| elondon          | real(dp) | 半経験的な分散エネルギー            |
| edftd3           | real(dp) | grimme-d3 分散エネルギー            |
| exdm             | real(dp) | XDM分散エネルギー                   |
| demet            | real(dp) | 金属の変分補正(-TS)                 |
| epaw             | real(dp) | １中心pawの寄与の和                 |
| ef, ef_up, ef_dw | real(dp) | フェルミエネルギー                  |

#### us

| name                      | type                  | content                    |
| ------------------------- | --------------------- | -------------------------- |
| nqxq                      | integer               | 補完テーブルのサイズ       |
| nqx                       | integer               | 補完する点の個数           |
| dq(default: 0.01)         | real(dp), parameter   | ポイント同士の間のスペース |
| qrad(:,:,:,:)             | real(dp), allocatable | Q関数の動径方向のFT        |
| tab(:,:,:)                | real(dp), allocatable | PPの補完テーブル           |
| tab_at(:,:,:)             | real(dp), allocatable | 原子wfcの補完テーブル      |
| spline_ps(default: false) | logical               |                            |
| tab_d2y(:,:,:)            | real(dp), allocatable | for cubic splines          |



klist中の変数 xk, wk, iskはノードごとに分割されている。あるノードでxk(1)などというかたちで値を参照したら、それは「そのプロセッサが担当しているk点の一つ目の座標」を表す。この分割を行っているのが、divide_et_impera.f90の65行目付近にある。