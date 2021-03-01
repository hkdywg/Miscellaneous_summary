#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>
#include <TI/tivx.h>
#include <app_init.h>

#include "vx_decoder_lib.h"
#include <sys/stat.h>
#include <unistd.h>

int32_t appInit()
{
    int32_t status = 0;

    status = appCommonInit();

    if(status==0)
    {
        tivxInit();
        tivxHostInit();
    }
    return status;
}

int32_t appDeInit()
{
    int32_t status = 0;

    tivxHostDeInit();
    tivxDeInit();
    appCommonDeInit();

    return status;
}

int app_decoder_main(int argc, char *argv[])
{
    int cnt = 0;
    uint8_t channel = 0;
    char file_name[NUM_CHANNEL][128];
    struct stat file_state[NUM_CHANNEL];
    FILE *input_fp[NUM_CHANNEL];
    FILE *output_fp[NUM_CHANNEL];
    uint64_t start_time = 0x00;
    uint64_t stop_time = 0x00;

    App_decode_Obj obj = {
        .decodeObj[0] = {
            .width = 1280,
            .height = 720,
        },
        .decodeObj[1] = {
            .width = 1280,
            .height = 720,
        },
#if (NUM_CHANNEL == 4)
        .decodeObj[2] = {
            .width = 1280,
            .height = 720,
        },
        .decodeObj[3] = {
            .width = 1280,
            .height = 720,
        },
#endif
    };
    app_init_resource(&obj);
    for(channel = 0; channel < NUM_CHANNEL; channel++)
    {
        app_decode_init(obj.context, &obj.decodeObj[channel]);
        app_create_graph_decode(obj.graph, &obj.decodeObj[channel]);
    }
    app_verify_graph(obj.graph);
    output_fp[0] = fopen("/root/output_1280_720_0.yuv","w");
    output_fp[1] = fopen("/root/output_1280_720_1.yuv","w");
    output_fp[2] = fopen("/root/output_1280_720_2.yuv","w");
    output_fp[3] = fopen("/root/output_1280_720_3.yuv","w");
    for(int i = 0;i < 50; i++)
    {
        for(channel = 0; channel < NUM_CHANNEL; channel++)
        {
            sprintf(file_name[channel],"%s%d%s%d%s", "/root/f.h264_", channel, "/", i, ".h264");
            input_fp[channel] = fopen(file_name[channel], "r");
            stat(file_name[channel], &file_state[channel]);
        }
    
        for(int j = 0; j < NUM_CHANNEL; j++)
        {
            obj.decodeObj[j].info.bitstream_sizes = file_state[j].st_size;
            fread(obj.decodeObj[j].info.streambuf, sizeof(uint8_t), obj.decodeObj[j].info.bitstream_sizes, input_fp[j]);
        } 
        
        app_run_decode(obj.graph, obj.decodeObj);


        for(int j = 0; j < NUM_CHANNEL; j++)
        {
            fwrite(obj.decodeObj[j].info.ptr_y, sizeof(uint8_t), obj.decodeObj[j].width * obj.decodeObj[j].height, output_fp[j]);
            fwrite(obj.decodeObj[j].info.ptr_uv, sizeof(uint8_t), obj.decodeObj[j].width * obj.decodeObj[j].height / 2, output_fp[j]);
        }
        for(channel = 0; channel < NUM_CHANNEL; channel++)
        {
            fclose(input_fp[channel]);
        }
//        usleep(10000);
    }
    for(channel = 0; channel < NUM_CHANNEL; channel++)
        fclose(output_fp[channel]);
    app_decode_deinit(&obj);
    return 0;
}

int main(int argc, char *argv[])
{
    int status = 0;
    status = appInit();

    if(status==0)
    {
        app_decoder_main(argc, argv);
        appDeInit();
    }

    return 0;
}
