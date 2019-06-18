<?php 
    $mysqli = new mysqli("", "", "", "");
    if ($mysqli->connect_error)
    {
        echo $mysqli->connect_error;
        exit();
    } 
    else
    {
        $mysqli->set_charset("utf8");
    }


    try 
    {
        $sql = "SELECT * FROM world_ranking";
        $res = $mysqli->query($sql);

        foreach ($res as $value) 
        {
            $temp = array();

            $temp = ['id'=>$value['id'],
                     'title'=>$value['title'],
                     '1st'=>$value['1st'], 
                     '2nd'=>$value['2nd'], 
                     '3rd'=>$value['3rd'],
                     '4th'=>$value['4th'],
                     '5th'=>$value['5th'],
                     '6th'=>$value['6th'],
                     '7th'=>$value['7th'],
                     '8th'=>$value['8th'],
                     '9th'=>$value['9th'],
                     '10th'=>$value['10th'],
                     'data1'=>$value['data1'],
                     'data2'=>$value['data2'],
                     'data3'=>$value['data3'],
                     'data4'=>$value['data4'],
                     'data5'=>$value['data5'],
                     'data6'=>$value['data6'],
                     'data7'=>$value['data7'],
                     'data8'=>$value['data8'],
                     'data9'=>$value['data9'],
                     'data10'=>$value['data10'],
                     'memo'=>$value['memo']
                    ];
            $data[] = $temp;
        }

        $php_json = json_encode($data, JSON_UNESCAPED_UNICODE);
        // $geo_data = var_dump($php_json);
        echo $php_json;

    }  catch(PDOException $e) {
        echo $e->getMessage();
        die();
    }

    $mysqli->close();

 ?>