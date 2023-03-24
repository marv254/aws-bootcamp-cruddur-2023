-- this file was manually created
INSERT INTO public.users (display_name, email, handle, cognito_user_id)
VALUES
  ('Andrew Brown','devopsmarv@gmail.com' , 'andrewbrown' ,'1a0ba4cc-b6a6-4da4-80ba-499909c02061'),
  ('Marvin Korir','marvinkorir.mk@gmail.com' , 'marvinkorir' ,'c6ced85c-4982-4d7e-ba6c-9189ac670b0d'),
  ('Iam Shmoney','iamshmoney@gmail.com' , 'iamshmoney' ,'4ab50a47-b433-4bad-9d81-eeeb4b7383b7')
  ;

INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'andrewbrown' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  )