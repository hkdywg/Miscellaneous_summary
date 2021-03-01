#include <VX/vx.h>
#include <VX/vxu.h>
#include <TI/tivx.h>
#include <string.h>
#include <stdio.h>
#include <tivx_utils_file_rd_wr.h>
#include <tivx_utils_checksum.h>
#include <TI/j7_video_decoder.h>
#include <TI/j7.h>

#define MAX_FILENAME_LEN   (1024u)
#define MAX_ITERATIONS     (100u)

#define NUM_CHANNEL  4

typedef struct {
    uint8_t * streambuf;
    vx_size bitstream_sizes;
    uint8_t * ptr_output;
    uint8_t * ptr_y;
    uint8_t * ptr_uv;
} stream_info;

typedef struct {
    vx_node node;
    vx_kernel kernel;
    tivx_video_decoder_params_t params;
    vx_user_data_object configuration_obj;
    vx_user_data_object bitstream_obj;
    vx_image output_image;
    vx_uint32 width;
    vx_uint32 height;
    stream_info info;
} DecodeObj;

typedef struct {
    vx_context context;
    vx_graph graph;
    DecodeObj decodeObj[NUM_CHANNEL];
} App_decode_Obj;


vx_status app_init_resource(App_decode_Obj *obj);
vx_status app_create_graph_decode(vx_graph graph, DecodeObj *decodeObj);
vx_status app_run_decode(vx_graph graph, DecodeObj *decodeObj);
vx_status app_decode_deinit(App_decode_Obj *obj);
vx_status app_verify_graph(vx_graph graph);
