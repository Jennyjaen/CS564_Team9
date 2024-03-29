setwd("C:/Users/youn/Desktop/R_5/3D_visualizing")
getwd()




library(ggplot2)
library(ggmap)
library(rayshader)
library(dplyr)
library(sp)
library(grid)
library(magick)
library(png)
library(gifski)
library(rlang)
library(rgl)

############ change memory size ############ 

memory.limit(size = 32000) 
memory.limit()

############ draw empty map ############ 
kormap <- readRDS("./data/geodata/gadm36_KOR_1_sp.rds")
kormapfd = fortify(kormap)

############ preprocessing for dot plot ############ 

names.eng.kor = data.frame(Eng_name = c("Busan","Chungcheongbuk-do","Chungcheongnam-do", "Daegu","Daejeon",
                                        "Gangwon-do", "Gwangju", "Gyeonggi-do", "Gyeongsangbuk-do",
                                        "Gyeongsangnam-do","Incheon","Jeju","Jeollabuk-do",
                                        "Jeollanam-do","Sejong","Seoul","Ulsan"),
                           Kor_name = c("부산", "충북", "충남", "대구", "대전",
                                        "강원", "광주", "경기", "경북", "경남",
                                        "인천", "제주", "전북", "전남", "세종",
                                        "서울", "울산"),
                           id = c(1,10,11,12,13,14,15,16,17,2,3,4,5,6,7,8,9))
# Id of names.eng.kor is same as kormapfd

############ get long and lat ############ 
kor.long.lat = data.frame()
for(i in names.eng.kor$id){
  #print(i)
  kor.long.lat = rbind(kor.long.lat, kormapfd %>% filter(id == i) %>% summarise(long = mean(long),lat = mean(lat)))
}
kor.long.lat = cbind(kor.long.lat, id= names.eng.kor$id)

############ little change for food visualization ############ 
kor.long.lat[1,]$long =  129.2029
kor.long.lat[1,]$lat =  35.15279
kor.long.lat[3,]$long =  126.9672
kor.long.lat[3,]$lat =  36.42187
kor.long.lat[4,]$long =  128.6075 
kor.long.lat[4,]$lat =  35.73772
kor.long.lat[5,]$long =  127.4657   
kor.long.lat[5,]$lat =  36.28762
kor.long.lat[6,]$long =  128.4957     
kor.long.lat[6,]$lat =  37.67871
kor.long.lat[7,]$long =  126.9552      
kor.long.lat[7,]$lat =  35.10388    
kor.long.lat[8,]$long =  127.3098       
kor.long.lat[8,]$lat =  37.15929  
kor.long.lat[9,]$long =  128.7886        
kor.long.lat[9,]$lat =  36.20868   
kor.long.lat[10,]$long =  128.3478         
kor.long.lat[10,]$lat =  35.24451    
kor.long.lat[11,]$long =  126.5672          
kor.long.lat[11,]$lat =  37.46187   
kor.long.lat[12,]$long =  126.5944           
kor.long.lat[12,]$lat =  33.36291   
kor.long.lat[13,]$long =  127.2419            
kor.long.lat[13,]$lat =  35.64812    
kor.long.lat[14,]$long =  126.9320             
kor.long.lat[14,]$lat =  34.7842      
kor.long.lat[15,]$long =  127.2871              
kor.long.lat[15,]$lat =  36.50711
kor.long.lat[16,]$long =  127.0717               
kor.long.lat[16,]$lat =  37.47785         
kor.long.lat[17,]$long =  129.3102                
kor.long.lat[17,]$lat =  35.48490           


############ Set map as 0 height, Change "kor_score" for other subjects ############
kormapfd_score_helper = data.frame(id = c(1,10,11,12,13,14,15,16,17,2,3,4,5,6,7,8,9),
                                   kor_score = rep(0,17)) 
kormapfd = merge(kormapfd,kormapfd_score_helper,by="id")


empty_map + 
  geom_point(data = kor.long.lat, aes(x=long , y=lat , color=id), size=2.5)
kor.long.lat.wname = merge(kor.long.lat, names.eng.kor, by="id")
#score_map

############ processing score ############
score.2015.wid = score.2015 %>%
  mutate(Kor_name = region) %>%
  merge(kor.long.lat.wname, by="Kor_name") %>%
  select(Kor_name, kor_score, kor_dev ,math_A_score, math_A_dev ,math_B_score ,math_B_dev ,id,long,lat)
score.2016.wid = score.2016 %>%
  mutate(Kor_name = region) %>%
  merge(kor.long.lat.wname, by="Kor_name") %>%
  select(Kor_name, kor_score, kor_dev ,math_A_score, math_A_dev ,math_B_score ,math_B_dev ,id,long,lat)
score.2016.wid$long = score.2016.wid$long + 0.05
score.2016.wid$lat = score.2016.wid$lat + 0.05 * 1.3
score.2017.wid = score.2017 %>%
  mutate(Kor_name = region) %>%
  merge(kor.long.lat.wname, by="Kor_name") %>%
  select(Kor_name, kor_score, kor_dev ,math_A_score, math_A_dev ,math_B_score ,math_B_dev ,id,long,lat)
score.2017.wid$long = score.2017.wid$long - 0.04
score.2017.wid$lat = score.2017.wid$lat + 0.04 * 2 * 1.5
score.2018.wid = score.2018 %>%
  mutate(Kor_name = region) %>%
  merge(kor.long.lat.wname, by="Kor_name") %>%
  select(Kor_name, kor_score, kor_dev ,math_A_score, math_A_dev ,math_B_score ,math_B_dev ,id,long,lat)
score.2018.wid$long = score.2018.wid$long - 0.05 -0.08
score.2018.wid$lat = score.2018.wid$lat + 0.05 * 1.3
score.2019.wid = score.2019 %>%
  mutate(Kor_name = region) %>%
  merge(kor.long.lat.wname, by="Kor_name") %>%
  select(Kor_name, kor_score, kor_dev ,math_A_score, math_A_dev ,math_B_score ,math_B_dev ,id,long,lat)
score.2019.wid$long = score.2019.wid$long - 0.08
score.2019.wid$lat = score.2019.wid$lat

kor_score_limit = c(93.6, 104.5)

############ save map size ############ 
empty_map = ggplot() + 
  geom_polygon(data = kormapfd, aes(x=long, y=lat, group=group), fill="white", color="black") +
  theme(legend.position = "none", 
                             axis.line=element_blank(), 
                             axis.text.x=element_blank(), axis.title.x=element_blank(),
                             axis.text.y=element_blank(), axis.title.y=element_blank(),
                             axis.ticks=element_blank(), 
                             panel.background = element_blank())
xlim = ggplot_build(empty_map)$layout$panel_scales_x[[1]]$range$range
ylim = ggplot_build(empty_map)$layout$panel_scales_y[[1]]$range$range

############ plot it as 3D ############
## https://www.rayshader.com/reference/plot_3d.html
## https://github.com/cydalytics/HK_Properties_Price_Distribution/blob/master/HK_Properties_Price_Distribution.R

map_2d = ggplot() + 
  geom_polygon(data = kormapfd, aes(x=long, y=lat, group=group, color=kor_score), fill="white") +
  xlim(xlim[1],xlim[2]) + # x-axis Mapping
  ylim(ylim[1],ylim[2]) + # y-axis Mapping
  geom_point(data=score.2015.wid, aes(x=long, y=lat, color=kor_score), size=1.4) + # Points
  geom_point(data=score.2016.wid, aes(x=long, y=lat, color=kor_score), size=1.4) + # Points
  geom_point(data=score.2017.wid, aes(x=long, y=lat, color=kor_score), size=1.4) + # Points
  geom_point(data=score.2018.wid, aes(x=long, y=lat, color=kor_score), size=1.4) + # Points
  geom_point(data=score.2019.wid, aes(x=long, y=lat, color=kor_score), size=1.4) + # Points
  scale_colour_gradient(name = 'Score of Korean', 
                        limits=kor_score_limit, 
                        low="#FCB9B2", high="#B23A48") + # Price Density Color
  theme(axis.line=element_blank(), 
        axis.text.x=element_blank(), axis.title.x=element_blank(),
        axis.text.y=element_blank(), axis.title.y=element_blank(),
        axis.ticks=element_blank(), 
        panel.background = element_blank()) # Clean Everything
map_2d
#plot_gg(map_2d, multicore = TRUE, fov = 70, scale = 100)
plot_gg(map_2d, multicore = TRUE, fov = 70, scale = 250, shadow = T,
        zoom = 0.85, phi = 45, theta = 290, sunangle = 135)
