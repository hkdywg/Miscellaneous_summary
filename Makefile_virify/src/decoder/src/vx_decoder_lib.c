#include "vx_decoder_lib.h"
#include <sys/stat.h>
#include <utils/console_io/include/app_log.h>

vx_status app_init_resource(App_decode_Obj *obj)
{
    vx_uint8 i = 0;
    vx_status status = VX_SUCCESS;

    obj->context = vxCreateContext();
    tivxHwaLoadKernels(obj->context);
    
    obj->graph = vxCreateGraph(obj->context);
    for(i = 0; i < NUM_CHANNEL; i++)
    {
        obj->decodeObj[i].info.ptr_output = malloc(4*1024*1024);
        obj->decodeObj[i].info.ptr_y = obj->decodeObj[i].info.ptr_output;
        obj->decodeObj[i].info.ptr_uv = obj->decodeObj[i].info.ptr_output + (obj->decodeObj[i].width * obj->decodeObj[i].height);
        obj->decodeObj[i].info.streambuf = malloc(4*1024*1024);
    }
    return status;
}

vx_status app_decode_init(vx_context context, DecodeObj *decodeObj)
{
    vx_status status = VX_SUCCESS;

    tivx_video_decoder_params_init(&decodeObj->params);
    decodeObj->configuration_obj = vxCreateUserDataObject(context, "tivx_video_decoder_params_t", sizeof(tivx_video_decoder_params_t), NULL);
    if(vxGetStatus((vx_reference)decodeObj->configuration_obj) != VX_SUCCESS)
    {
        printf("configuration create failed!\n");
        return VX_FAILURE;
    }
    decodeObj->bitstream_obj = vxCreateUserDataObject(context, "video_bitstream", sizeof(uint8_t) * decodeObj->width * decodeObj->height * 3 / 2, NULL);

    decodeObj->params.bitstream_format = TIVX_BITSTREAM_FORMAT_H264;

    vxCopyUserDataObject(decodeObj->configuration_obj, 0, sizeof(tivx_video_decoder_params_t), &decodeObj->params, VX_WRITE_ONLY, VX_MEMORY_TYPE_HOST);

    decodeObj->output_image = vxCreateImage(context, decodeObj->width, decodeObj->height, VX_DF_IMAGE_NV12);

    return status;
}

vx_status app_create_graph_decode(vx_graph graph, DecodeObj *decodeObj)
{
    vx_status status = VX_SUCCESS; 
    decodeObj->node = tivxVideoDecoderNode(graph,
                                       decodeObj->configuration_obj,
                                       decodeObj->bitstream_obj,
                                       decodeObj->output_image);
    vxSetNodeTarget(decodeObj->node, VX_TARGET_STRING, TIVX_TARGET_VDEC1);

    return status;
}

vx_status app_run_decode(vx_graph graph, DecodeObj *decodeObj)
{
    vx_status status = VX_SUCCESS;
    vx_uint8 *bitstream[NUM_CHANNEL];
    vx_map_id map_id[NUM_CHANNEL];
    static FILE *out_fp;
    vx_rectangle_t             rect_y;
    vx_rectangle_t             rect_uv;
    vx_map_id                  map_id_image_y[NUM_CHANNEL];
    vx_imagepatch_addressing_t image_addr_y[NUM_CHANNEL];
    vx_map_id                  map_id_image_uv[NUM_CHANNEL];
    vx_imagepatch_addressing_t image_addr_uv[NUM_CHANNEL];
    uint8_t                  *data_ptr_y[NUM_CHANNEL];
    uint8_t                  *data_ptr_uv[NUM_CHANNEL];
    uint32_t num_read = 0x00;
    uint32_t i,j;

    for(i = 0; i < NUM_CHANNEL; i++)
    {
        vxMapUserDataObject(decodeObj[i].bitstream_obj, 0, decodeObj[i].info.bitstream_sizes, &map_id[i], (void*) &bitstream[i], VX_WRITE_ONLY, VX_MEMORY_TYPE_HOST, 0);
        memcpy(bitstream[i], decodeObj[i].info.streambuf, decodeObj[i].info.bitstream_sizes);
        vxUnmapUserDataObject(decodeObj[i].bitstream_obj, map_id[i]);
        tivxSetUserDataObjectAttribute(decodeObj[i].bitstream_obj,  TIVX_USER_DATA_OBJECT_VALID_SIZE, (void*)&(decodeObj[i].info.bitstream_sizes), sizeof(vx_size));
    }
    vxProcessGraph(graph);

    for(i = 0; i < NUM_CHANNEL; i++)
    {
        rect_y.start_x = 0;
        rect_y.start_y = 0;
        rect_y.end_x = decodeObj[i].width;
        rect_y.end_y = decodeObj[i].height;

        rect_uv.start_x = 0;
        rect_uv.start_y = 0;
        rect_uv.end_x = decodeObj[i].width;
        rect_uv.end_y = decodeObj[i].height / 2;


        vxMapImagePatch(decodeObj[i].output_image,
                                &rect_y,
                                0,
                                &map_id_image_y[i],
                                &image_addr_y[i],
                                (void**) &decodeObj[i].info.ptr_y,
                                VX_READ_ONLY,
                                VX_MEMORY_TYPE_HOST,
                                VX_NOGAP_X
                                );

        vxMapImagePatch(decodeObj[i].output_image,
                                &rect_uv,
                                1,
                                &map_id_image_uv[i],
                                &image_addr_uv[i],
                                (void**) &decodeObj[i].info.ptr_uv,
                                VX_READ_ONLY,
                                VX_MEMORY_TYPE_HOST,
                                VX_NOGAP_X
                                );
    }
    for(i = 0; i < NUM_CHANNEL; i++)
    {
        vxUnmapImagePatch(decodeObj[i].output_image, map_id_image_y[i]);
        vxUnmapImagePatch(decodeObj[i].output_image, map_id_image_uv[i]);
    }
    return status;
}


vx_status app_decode_deinit(App_decode_Obj *obj)
{
    vx_status status = VX_SUCCESS;
    uint8_t channel = 0;

    for(channel = 0; channel < NUM_CHANNEL; channel++)
    {
        vxReleaseNode(&obj->decodeObj[channel].node);
    }
    vxReleaseGraph(&obj->graph);
    for(channel = 0; channel < NUM_CHANNEL; channel++)
    {
        vxReleaseImage(&obj->decodeObj[channel].output_image);
        vxReleaseUserDataObject(&obj->decodeObj[channel].bitstream_obj);
        vxReleaseUserDataObject(&obj->decodeObj[channel].configuration_obj);
        if(obj->decodeObj[channel].info.ptr_output)
        {
            free(obj->decodeObj[channel].info.ptr_output);
            obj->decodeObj[channel].info.ptr_output = NULL;
        }
        if(obj->decodeObj[channel].info.streambuf)
        {
            free(obj->decodeObj[channel].info.streambuf);
            obj->decodeObj[channel].info.streambuf = NULL;
        }
    }
    tivxHwaUnLoadKernels(&obj->context);

    return status;
}

vx_status app_verify_graph(vx_graph graph)
{
    vx_status status = VX_SUCCESS;
    status = vxVerifyGraph(graph);    
    tivxTaskWaitMsecs(200);
    return status;
}

