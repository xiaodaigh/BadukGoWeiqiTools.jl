using JSON3
using Serialization
NAME_DB_JSON = "playerdb-2021-05-03.json"

export create_names_db, NAMESDB


function create_names_db(NAME_DB_JSON; force=false)
    if isfile("c:/git/BadukGoWeiqiTools/src/namesdb") & !force
        deserialize("c:/git/BadukGoWeiqiTools/src/namesdb")
    else
        text = readline(NAME_DB_JSON);
        json = JSON3.read(text);

        simplenames = Dict{String, String}()

        for json1 in json
            key = json1.key_name
            for name in json1.names
                any_in_go4go = filter(jn->"Go4go" in jn.databases, name.simplenames)
                if length(any_in_go4go) >= 1
                    key = any_in_go4go[1].name
                end
            end

            tmpnames = String[]
            for name in json1.names
                for sn in name.simplenames
                    simplenames[sn.name] = key
                end
            end

        end

        # manuals
        manuals = Dict("金禹丞"=>"Jin Yucheng",
                        "王春晖"=>"Wang Chunhui",
                        "许一笛"=>"Xu Yidi",
                        "黄明宇"=>"Huang Mingyu",
                        "申旻俊"=>"Shin Minjun",
                        "陈一纯"=>"Chen Yichun",
                        "叶长欣"=>"Ye Changxin",
                        "李泽锐"=>"Li Zerui",
                        "吕立言"=>"Lyu Liyan",
                        "何語涵"=>"He Yuhan",
                        "王春暉"=>"Wang Chunhui",
                        "蒋其潤"=>"Jiang Qirun",
                        "張涛"=>"Zhang Tao",
                        "李維清"=>"Li Weiqing",
                        "屠暁宇"=>"Tu Xiaoyu",
                        "陳賢"=>"Chen Xian",
                        "郭信駅"=>"Guo Xinyi",
                        "謝科"=>"Xie Ke",
                        "陳浩"=>"Chen Hao",
                        "王沢錦"=>"Wang Zejin",
                        "楊楷文"=>"Yang Kaiwen",
                        "劉宇航"=>"Liu Yuhang",
                        "陳梓健"=>"Chen Zijian",
                        "陳玉儂"=>"Chen Yunong",
                        "許一笛"=>"Xu Yidi",
                        "胡鈺函"=>"Hu Yuhan",
                        "鄭胥"=>"Zheng Xu",
                        "伊淩濤"=>"Yi Lingtao",
                        "韓一洲"=>"Han Yizhou",
                        "陳正勲"=>"Chen Zhengxun",
                        "許嘉陽"=>"Xu Jiayang",
                        "趙晨宇"=>"Zhao Chenyu",
                        "李沢鋭"=>"Li Zerui",
                        "陳一純"=>"Chen Yichun",
                        "葉長欣"=>"Ye Changxin",
                        "呂立言"=>"Lyu Liyan",
                        "申真諝"=>"Shin Jinseo",
                        "姜知勲"=>"Kang Jihoon",
                        "沈載益"=>"Shen Zaiyi",
                        "白現宇"=>"Baek Hyeonwoo",
                        "韓相朝"=>"Chao Xiangzhao",
                        "李元栄"=>"Lee Wonyoung",
                        "朴常鎭"=>"Park Sangjin",
                        "崔宰栄"=>"Choi Jaeyoung",
                        "曹瀟陽"=>"Cao Xiaoyang",
                        "文儒彬"=>"Wen Rubin",
                        "文敏鍾"=>"Moon Minjong",
                        "金炅奐"=>"Kim Ilhwan",
                        "張強"=> "Zhang Qiang",
                        "簡靖庭"=>"Jian Jingting",
                        "賴均輔"=>"Lai Junfu",
                        "渡辺寛大"=>"Watanabe Kandai",
                        "崔光戸"=>"Choi Kyeongho",
                        "黄静遠"=>"Huang Jingyuan",
                        "陸敏全"=>"Lu Minquan",
                        "韓宇進"=>"Han Woojin",
                        "尭瀟童"=>"Yao Xiaotong",
                        "申載元" => "Shin Jaeweon",
                        "成家業" => "Cheng Jiaye",
                        "関航太郎" => "Seki Kotaro",
                        "盧奕銓" => "Lu Yiquan",
                        "鄭宇津" => "Zheng Yujin",
                        "仲邑菫" => "Nakamura Sumire",
                        "朴鐘勲" => "Park Joonhoon",
                        "白賛僖" => "Baek Chanhee",
                        "宋知勲" => "Song Jihoon",
                        "琴沚玗" => "Gon Jiwoo",
                        "金相天" => "Kim Sangcheon",
                        "李炫準" => "Lee Hyeonjun",
                        "福岡航太朗"=>"Fukuoka Kotaro",
                        "林漢傑" => "Rin Kanketsu",
                        "林傑漢" => "Lin Jiehan"
                        )

        merge!(simplenames, manuals)

        serialize("namesdb", simplenames)

        simplenames
    end
end


const NAMESDB = create_names_db(joinpath("c:/git/BadukGoWeiqiTools/src/", NAME_DB_JSON); force=true);
