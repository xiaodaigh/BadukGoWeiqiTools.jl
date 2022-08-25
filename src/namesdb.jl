using JSON3
using Serialization
using TableScraper: scrape_tables

using CodecZlib: GzipDecompressor

export load_namesdb, create_names_to_nationality_tbl, download_latest_ugo


function download_latest_ugo()
    latest_row = scrape_tables("https://u-go.net/playerdb-archive/", identity)[1].rows[2]
    link = latest_row[3][1].attributes["href"]
    http = HTTP.request("GET", link)

    JSON3.read(transcode(GzipDecompressor, http.body))
end

"""
Save a namesdb file somehwere
"""
function load_namesdb(path = "namesdb"; force = false)
    if force | !isfile(path)
        # download latest names database from ugo.net
        json = download_latest_ugo()
        name_dict = create_names_db(json)
        serialize(path, name_dict)
        merge!(name_dict, manuals)
        return name_dict
    else
        @info "You are loading the cached namesdb at `$path`"
        simplenames = deserialize(path)
        simplenames = merge(manuals, simplenames)
        return simplenames
    end
end

# manuals
manuals = Dict("金禹丞" => "Jin Yucheng",
    "王春晖" => "Wang Chunhui",
    "许一笛" => "Xu Yidi",
    "黄明宇" => "Huang Mingyu",
    "申旻俊" => "Shin Minjun",
    "陈一纯" => "Chen Yichun",
    "叶长欣" => "Ye Changxin",
    "李泽锐" => "Li Zerui",
    "吕立言" => "Lyu Liyan",
    "何語涵" => "He Yuhan",
    "王春暉" => "Wang Chunhui",
    "蒋其潤" => "Jiang Qirun",
    "張涛" => "Zhang Tao",
    "李維清" => "Li Weiqing",
    "屠暁宇" => "Tu Xiaoyu",
    "陳賢" => "Chen Xian",
    "郭信駅" => "Guo Xinyi",
    "謝科" => "Xie Ke",
    "陳浩" => "Chen Hao",
    "王沢錦" => "Wang Zejin",
    "楊楷文" => "Yang Kaiwen",
    "劉宇航" => "Liu Yuhang",
    "陳梓健" => "Chen Zijian",
    "陳玉儂" => "Chen Yunong",
    "許一笛" => "Xu Yidi",
    "胡鈺函" => "Hu Yuhan",
    "鄭胥" => "Zheng Xu",
    "伊淩濤" => "Yi Lingtao",
    "韓一洲" => "Han Yizhou",
    "陳正勲" => "Chen Zhengxun",
    "許嘉陽" => "Xu Jiayang",
    "趙晨宇" => "Zhao Chenyu",
    "李沢鋭" => "Li Zerui",
    "陳一純" => "Chen Yichun",
    "葉長欣" => "Ye Changxin",
    "呂立言" => "Lyu Liyan",
    "申真諝" => "Shin Jinseo",
    "姜知勲" => "Kang Jihoon",
    "沈載益" => "Sim Jaeik",
    "白現宇" => "Baek Hyeonwoo",
    "李元栄" => "Lee Wonyoung",
    "朴常鎭" => "Park Sangjin",
    "崔宰栄" => "Choi Jaeyoung",
    "曹瀟陽" => "Cao Xiaoyang",
    "文儒彬" => "Wen Rubin",
    "文敏鍾" => "Moon Minjong",
    "金炅奐" => "Kim Ilhwan",
    "張強" => "Zhang Qiang",
    "簡靖庭" => "Jian Jingting",
    "賴均輔" => "Lai Junfu",
    "渡辺寛大" => "Watanabe Kandai",
    "崔光戸" => "Choi Kyeongho",
    "黄静遠" => "Huang Jingyuan",
    "陸敏全" => "Lu Minquan",
    "韓宇進" => "Han Woojin",
    "尭瀟童" => "Yao Xiaotong",
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
    "福岡航太朗" => "Fukuoka Kotaro",
    "林漢傑" => "Rin Kanketsu",
    "林傑漢" => "Lin Jiehan",
    "兪俐均" => "Yu Lijun",
    "陳一鳴" => "Chen Yiming",
    "戦鷹" => "Zhan Ying",
    "林聖弈" => "Lin Shengyi",
    "潘陽" => "Pan Yang",
    "趙恵連" => "Cho Hyeyeon",
    "徐靖恩" => "Xu Jingen",
    "呉政娥" => "Oh Jeonga",
    "陳豪鑫" => "Chen Haoxin",
    "王禹程" => "Wang Yucheng",
    "鄭載想" => "Zheng Zaixiang",
    "呂立言" => "Lyu Liyan",
    "肖泽彬" => "Xiao Zebin",
    "何雨涵" => "He Yuhan",
    "陈玉浓" => "Chen Yunong",
    "劉川霆" => "Liu Chuanting",
    "楊子萱" => "Yang Zixuan",
    "白昕卉" => "Bai Xinhui",
    "曺承亜" => "Cho Seungah",
    "劉一芳" => "Liu Yifang",
    "林鈺娗" => "Lin Yuting",
    "金昌勲" => "Kim Changhoon",
    "劉兆哲" => "Liu Zhaozhe",
    "花暢" => "Hua Chang",
    "金凡瑞" => "Kim Beomseo",
    "馬逸超" => "Ma Yichao",
    "王碩" => "Wang Shuo",
    "朴廷恒" => "Park Junghwan",
    "黄春晖" => "Wang Chunhui", # sic
    "刘宇航" => "Liu Yuhang",
    "曹承亚" => "Cho Seungah",
    "羋昱廷" => "Mi Yuting",
    "胡子豪" => "Hu Zihao",
    "赵完珪" => "Cho Wankyu",
    "傅健恒" => "Fu Jianheng",
    "許栄珞" => "Heo Youngrak",
    "韓友賑" => "Han Woojin",
    "金恩持" => "Kim Eunji",
    "張東岳" => "Zhang Dongyue",
    "呉梓天" => "Wu Zitian",
    "唐嘉雯" => "Tang Jiawen",
    "吴依铭" => "Wu Yiming",
    "盧鈺樺" => "Lu Yuhua",
    "仲邑菫" => "Nakamura Sumire",
    "조승아" => "Cho Seungah",
    "조완규" => "Cho Wankyu",
    "金孝英" => "Kim Hyoyoung",
    "金魯炅" => "Kim Nokyeong",
    "呉依銘" => "Wu Yiming",
    "李尚憲" => "Lee Sanghun",
    "Geum Jiwoo" => "Gon Jiwoo",
    "兪旿成" => "Yoo Ohseong",
    "韓相朝" => "Han Sangcho",
    "金宣圻" => "Kim Seongji",
    "郭圓根" => "Kwak Wonkeun",
    "趙完珪" => "Cho Wankyu",
    "仇丹雲" => "Qiu Danyun",
    "陳国興" => "Chen Guoxing",
    "陳芊瑜" => "Chen Qianyu",
    "陳必森" => "Chen Bisen",
    "加藤千笑" => "Kato Chie",
    "辰己茜" => "Akane Tatsumi",
    "高雄茉莉" => "Takao Mari",
    "沈載益" => "Sim Jaeik",
    "李沇" => "Lee Yeon",
    "王楚軒"=>"Wang Chuxuan",
    "崔基勲" => "Choi Kihoon",
    "林賞圭" => "Im Sanggyu",
    "李瑟珠" => "Lee Suljoo",
    "許瑞玹" => "Heo Seohyun",
    "呉秉祐" => "Oh Byungwoo",
    "趙奕斐" => "Zhao Yifei",
    "儲可児" => "Chu Keer",
    "牛詩特" => "Niu Shite",
    "権孝珍" => "Gueon Hyojin",
    "李小渓" => "Li Xiaoxi",
    "李鑫怡" => "Li Xinyi",
    "陳首廉" => "Chen Shoulian",
    "林彦丞" => "Lin Yanchen",
    "張子涵" => "Zhang Zhihan",
    "李宜炫" => "Lee Euihyun",
    "陳威廷" => "Chen Weiting",
    "曾品傑" => "Zeng Pinjie",
    "朴ジンソル" => "Park Jinsol",
    "王沢宇" => "Wang Zheyu",
    "鄭有珍" => "Jeong Yujin",
    "王楚轩" => "Wang Chuxuan",
    "李昊潼" => "Li Haotong",
    "成家业" => "Cheng Jiaye",
    "王泽宇" => "Wang Zeyu",
    "李欣宸" => "Li Xinchen",
    "王硕00" => "Wang Shuo",


    # yellow doesn't exist in go4go but could be  => "Choi Jeonggwan",
    "김지우" =>	"Kim Jiwoo",
    "김승진" =>	"Kim Seungjin",
    "김성재" =>	"Kim Seongjae (2)",
    "임진욱" =>	"Im Jinwook",
    "김윤태" =>	"Kim Yuntae",
    "원제훈" =>	"Won Jehoon",
    "서윤서" =>	"Seo Yoonseo",
    "최원진" =>	"Choi Wonjin",
    "김현빈" =>	"Kim Hyunbin",
    "신현석" =>	"Shin Hyunseok",
    "조영숙" =>	"Cho Youngsook",
    "허재원" =>	"Heo Jaewon",
    "김사우" =>	"Kim Sawoo",
    "이해원" =>	"Lee Haewon",
    "김승구" =>	"Kim Seunggoo",
    "이승민" =>	"Lee Seungmin",

    # green: gazza thinks go4go is wrong
    "유주현" =>	"Yoo Joohyun",
    "이상헌" =>	"Lee Sanghun (5p)",
    "김선빈" =>	"Kim Seonbin",

    # white: suppose to be in go4go
    "이영주" =>	"Lee Youngjoo",
    "조완규" =>	"Cho Wankyu",
    "이재성" =>	"Lee Jaesung",
    "김민서" =>	"Kim Minseo",
    "장은빈" =>	"Jang Eunbin",
    "김상천" =>	"Kim Sangcheon",
    "조승아" =>	"Cho Seungah",
    "박신영" =>	"Park Sinyoung",
    "박종훈" =>	"Park Jonghoon",
    "심재익" =>	"Sim Jaeik",
    "이유진" =>	"Lee Yujin",
    "문지환" =>	"Moon Jihwan",
    "장건현" =>	"Chang Geonhyun",
    "박정근" =>	"Park Jeonggeon",
    "김누리" =>	"Kim Nuri",
    "한우진" =>	"Han Woojin",
    "김선기" =>	"Kim Seongi",
    "김효영" =>	"Kim Hyoyoung",
    "문명근" =>	"Moon Myunggun",
    "강지범" =>	"Kang Jibum",
    "김기범" =>	"Kim Kibum",
    "박진열" =>	"Park Jinyeol",
    "강지훈" =>	"Kang Jihoon",
    "선승민" =>	"Seon Seungmin",
    "김민정" =>	"Kim Minjeong",
    "오승민" =>	"Oh Seungmin",
    "최원용" =>	"Choi Wongyong",
    "이현준" =>	"Lee Hyeonjun",
    "서무상" =>	"Seo Musang",
    "윤예성" =>	"Yun Yeseong",
    "허서현" =>	"Heo Seohyun",
    "이성재" =>	"Lee Seongjae",
    "강지수" =>	"Kang Jisoo",
    "한상조" =>	"Han Sangcho",
    "권주리" =>	"Kwon Juri",
    "강다정" =>	"Kang Dajeong",
    "최민서" =>	"Choi Minseo",
    "윤성식" =>	"Yun Seongsik",
    "오병우" =>	"Oh Byeongwoo",
    "최광호" =>	"Choi Kyeongho",
    "정유진" =>	"Jeong Yujin",
    "홍석민" =>	"Hong Seokmin",
    "이도현" =>	"Lee Dohyun",
    "정서준" =>	"Jeong Seojun",
    "김지명" =>	"Kim Jimyeong",
    "신재원" =>	"Shin Jaewon",
    "송규상" =>	"Song Gyusang",
    "김영삼" =>	"Kim Yeongsam",
    "차수권" =>	"Cha Sookwon",
    "배준희" =>	"Bae Junhee",
    "박지현" =>	"Park Jihyun",
    "백현우" =>	"Baek Hyeonwoo",
    "박태희" =>	"Park Taehee",
    "김동우" =>	"Kim Dongwoo",
    "김영광" =>	"Kim Yeongkwang",
    "김정선" =>	"Kim Jeongsun",
    "곽원근" =>	"Kwak Wonkeun",
    "금지우" =>	"Geum Jiwoo",
    "이기섭" =>	"Lee Kisup",
    "주치홍" =>	"Ju Chihong",
    "박상진" =>	"Park Sangjin",
    "위태웅" =>	"Wi Taewoong",
    "김노경" =>	"Kim Nokyeong",
    "박정수" =>	"Park Jungsoo",
    "박소율" =>	"Park Soyul",
    "박지영" =>	"Park Jiyoung",
    "이승준" =>	"Lee Seungjun",
    "윤민중" =>	"Yun Minjung",
    "양건" =>	"Yang Keon",
    "박성수" =>	"Park Seunsoo",
    "김경환" =>	"Kim Kyeonghwan",
    "허영락" =>	"Heo Youngrak",
    "박동주" =>	"Park Dongjoo",
    "심준섭" =>	"Sim Junseop",
    "김세현" =>	"Kim Sehyun",
    "디아나" =>	"Diana Koszegi",
    "양유준" =>	"Yang Yoojun",
    "김범서" =>	"Kim Beomseo",
    "문민종" =>	"Moon Minjong",
    "정우진" =>	"Jeong Woojin",
    "강우혁" =>	"Kang Woohyuk",
    "이의현" =>	"Lee Euihyun",
    "정두호" =>	"Jeong Dooho",
    "김강민" =>	"Kim Kangmin",
    "최진원" =>	"Choi Jinwon",
    "윤혁" =>	"Yun Hyuk",
    "김선호" =>	"Kim Sunho",
    "김은지" =>	"Kim Eunji",
    "이연" =>	"Lee Yeon",
    "김경은" =>	"Kim Kyeongeun",
    "김상인" =>	"Kim Sangin",
    "김철중" =>	"Kim Chuljung",
    "윤희우" =>	"Yun Heewoo",
    "전용수" =>	"Jen Yongsoo",
    "조남균" =>	"Cho Namkyun",
    "최은규" =>	"Choi Eungyu",
    "김준석" =>	"Kim Joonseok",
    "이슬주" =>	"Lee Suljoo",
    "현유빈" =>	"Hyun Yoobin",
    "김창훈" =>	"Kim Changhoon",
    "윤현빈" =>	"Yun Hyunbin",
    "양민석" =>	"Yang Minseok",
    "김유찬" =>	"Kim Yoochan",
    "유오성" =>	"Yoo Ohseong",
    "박현수" =>	"Park Hyunsoo",
    "김기원" => "Kim Kiwon"

)

function create_names_db(json::JSON3.Array)
    # if isfile("c:/git/BadukGoWeiqiTools/src/namesdb") & !force
    #     deserialize("c:/git/BadukGoWeiqiTools/src/namesdb")
    # else
    simplenames = Dict{String,String}()
    for json1 in json
        key = json1.key_name
        for name in json1.names
            any_in_go4go = filter(jn -> "Go4go" in jn.databases, name.simplenames)
            if length(any_in_go4go) >= 1
                key = any_in_go4go[1].name
            end
        end

        for name in json1.names
            for sn in name.simplenames
                simplenames[sn.name] = key
            end
        end

    end

    simplenames
end

function create_names_db(path_to_json::String; kwargs...)
    text = readline(NAME_DB_JSON)
    json = JSON3.read(text)

    create_names_db(json; kwargs...)
end


function create_player_info_tbl()
    json = download_latest_ugo()

    res = Dict()
    for json1 in json
        key = json1.key_name
        for name in json1.names
            any_in_go4go = filter(jn -> "Go4go" in jn.databases, name.simplenames)
            if length(any_in_go4go) >= 1
                key = any_in_go4go[1].name
            end
        end


        res[key] = (json1.citizenship, json1.affiliation, json1.date_of_birth, json1.sex)
    end

    df = DataFrame(
        name=keys(res) |> collect,
        nationality=[val[1] for val in values(res)],
        affiliation=[val[2] for val in values(res)],
        date_of_birth=[val[3] for val in values(res)],
        sex=[val[4] for val in values(res)],
    )

    function update_birthday!(name, bday)
        idx = indexin(Ref(name), df.name)[1]
        df[idx, :date_of_birth] = bday
        df
    end

    update_birthday!("Zhao Chenyu", "1999-06-04")
    update_birthday!("Chen Xian", "1997-05-11")
    update_birthday!("Xu Haohong", "2001-04-30")
    update_birthday!("Jiang Qirun", "2000-10-12")
    update_birthday!("Xie Ke", "2000-01-14")
    update_birthday!("Yi Lingtao", "2000-05-29")
    update_birthday!("Yi Lingtao", "2000-05-29")
    update_birthday!("Liu Yuhang", "2001-07-18")
    update_birthday!("Liu Yuhang", "2001-07-18")
    update_birthday!("Park Sangjin", "2001-05-19")
    update_birthday!("Hu Yuhan", "1996-11-27")
    update_birthday!("Song Gyusang", "1998-09-28")
    update_birthday!("Lai Junfu", "2002-04-08")
    update_birthday!("Chen Haoxin", "2004-01-05")
    update_birthday!("Chen Qirui", "2000-06-15")
    update_birthday!("Wi Taewoong", "1993-12-28")
    update_birthday!("Park Joonhoon", "2000-01-14")
    update_birthday!("Wang Xinghao", "2004-02-02")
    update_birthday!("Ding Hao", "2000-06-13")
    update_birthday!("Li Weiqing", "2000-04-10")
    update_birthday!("Liao Yuanhe", "2000-12-20")
    # update_birthday!("Shin Jaeweon", "2000-02-16")
    # update_birthday!("Baek Hyeonwoo", "2001-02-12")


    function update_natinoality!(name, region)
        idx = indexin(Ref(name), df.name)[1]
        df[idx, :nationality] = region
        df
    end

    update_natinoality!("Wang Xinghao", "CHN")

    function update_sex!(name, sex)
        @assert sex in ("Male", "Female")
        idx = indexin(Ref(name), df.name)[1]
        df[idx, :sex] = sex
        df
    end

    update_sex!("Wang Xinghao", "Male")


    manual = vcat(
        DataFrame(
            name="Jin Yucheng",
            nationality="CHN",
            affiliation="Chinese Weiqi Association",
            date_of_birth="2004-06-23",
            sex="Male"
        ),
        DataFrame(
            name="Sim Jaeik",
            nationality="KOR",
            affiliation="Korean Baduk Assoication",
            date_of_birth="1998-10-04",
            sex="Male"
        ),
        DataFrame(
            name="Heo Youngrak",
            nationality="KOR",
            affiliation="Korean Baduk Assoication",
            date_of_birth="1996-03-01",
            sex="Male"
        ),
        # DataFrame(
        #     name="Wang Xinghao",
        #     nationality="CHN",
        #     affiliation="Chinese Weiqi Association",
        #     date_of_birth="2004-02-02",
        #     sex="Male"
        # ),
    )



    return vcat(df, manual)
end